-- ~/Documents/GitHub/LDSLibrary.nvim/lua/myplugin/commands/fetch_html.lua
local gf = require("LDSLibrary.utils.global_functions")
local lib = require("LDSLibrary.tables.scripturetables")
local markdown = require("LDSLibrary.utils.markdown")
local curl = require("plenary.curl")

table.unpack = table.unpack or unpack
local M = {}

local function contains(table, element)
	for _, value in ipairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

local function get_short_volume_name(book)
	if contains(lib.newtestament, book) then
		return "nt"
	elseif contains(lib.oldtestament, book) then
		return "ot"
	elseif contains(lib.pgp, book) then
		return "pgp"
	elseif contains(lib.bofm, book) then
		return "bofm"
	elseif contains(lib.dnc, book) then
		return "dc-testament"
	end
end

-- Function to remove HTML tags

local function remove_html_tags(str)
	return str:gsub("<.->", "")
end
-- Function to extract paragraphs
local function extract_paragraphs(html)
	local paragraphs = {}
	for p_tag in html:gmatch('<p class=\\"verse\\".-</p>') do
		-- print("P_TAG: ",p_tag)
		local verse_number = gf.strip(p_tag:match('<span class=\\"verse%-number\\">(.-)</span>') or "")
		local verse_text = p_tag:gsub('<span class=\\"verse%-number\\">.-</span>', ""):match('">(.-)</p>') or ""
		-- Remove additional HTML tags from verse text
		verse_text = remove_html_tags(verse_text)
		paragraphs[verse_number] = verse_text
	end
	return paragraphs
end

local function insert_text(text)
	-- local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
	-- vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, text)
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1] - 1 -- Convert to 0-indexed
	local col = cursor[2]

	-- Insert the text at the current cursor location
	vim.api.nvim_buf_set_text(bufnr, row, col, row, col, text)
end

local function insert_reference(verses_to_insert, reference)
	local obsidian_reference = markdown.format_obsidian_reference(reference, verses_to_insert)
	insert_text(obsidian_reference)
	-- insert_text(obsidian_reference.md_verses)
end

local function is_table_empty(t)
	for _ in pairs(t) do
		return false
	end
	return true
end

function M.scripturequery(queries, opts)
	local language = opts.language or "eng"
	for _, reference in ipairs(queries) do
		local book = reference.book
		local chapter = reference.chapter
		local verses = reference.verses
		local short_volume = get_short_volume_name(book)
		local short_book = lib.short_books[book]

		local url = string.format(
			"https://www.churchofjesuschrist.org/study/api/v3/language-pages/type/content?lang=%s&uri=/scriptures/%s/%s/%s",
			language,
			short_volume,
			short_book,
			chapter
		)
		-- print(url)
		local result = curl.get(url)

		-- Check if the request was successful
		if result.status ~= 200 then
			print("Failed to fetch data from the URL. Status code:", result.status)
		else
			local body = result.body
			local jsondata = vim.fn.json_decode(body)
			local in_language_title = jsondata.meta.title
			reference.in_language_title = in_language_title
			local urlbit = jsondata.meta.canonicalUrl
			reference.cannonical_url = string.format("https://www.churchofjesuschrist.org/study/%s", urlbit)
			-- print(vim.inspect(reference))
			-- print(vim.inspect(in_language_title))
			-- print("json body: ",jsondata.content.body)
			-- print("json body type: ",type(jsondata.content.body))
			-- print("body orig type: ", type(body))
			-- For some reason trying to get 'jsondata.content.body' errors out and crashes the program.
			-- but just the raw text data isn't an issue.
			local paragraphs = extract_paragraphs(body)
			local verses_to_insert = {}
			local all_verses = {}
			for num, verse in pairs(paragraphs) do
				-- print(num,verse)
				all_verses[tonumber(num)] = verse
			end
			-- print(vim.inspect(paragraphs))
			-- print("verses: ", vim.inspect(verses))
			if is_table_empty(verses) then
				-- print("Empty verses table. will get all of them.")
				verses_to_insert = all_verses
			else
				for _, verse in ipairs(verses) do
					-- print(verse, paragraphs[verse])
					verses_to_insert[tonumber(verse)] = paragraphs[verse]
				end
			end
			insert_reference(verses_to_insert, reference)
		end
	end
end

return M
