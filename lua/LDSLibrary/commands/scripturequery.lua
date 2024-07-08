-- ~/Documents/GitHub/LDSLibrary.nvim/lua/myplugin/commands/fetch_html.lua
local curl = require("plenary.curl")
table.unpack = table.unpack or unpack

local function strip(inputstr)
	return (inputstr:gsub("^%s*(.-)%s*$", "%1"))
end

local newtestament = {
	"Matthew",
	"Mark",
	"Luke",
	"John",
	"Acts",
	"Romans",
	"1 Corinthians",
	"2 Corinthians",
	"Galatians",
	"Ephesians",
	"Philippians",
	"Colossians",
	"1 Thessalonians",
	"2 Thessalonians",
	"1 Timothy",
	"2 Timothy",
	"Titus",
	"Philemon",
	"Hebrews",
	"James",
	"1 Peter",
	"2 Peter",
	"1 John",
	"2 John",
	"3 John",
	"Jude",
	"Revelation",
}
local oldtestament = {
	"Genesis",
	"Exodus",
	"Leviticus",
	"Numbers",
	"Deuteronomy",
	"Joshua",
	"Judges",
	"Ruth",
	"1 Samuel",
	"2 Samuel",
	"1 Kings",
	"2 Kings",
	"1 Chronicles",
	"2 Chronicles",
	"Ezra",
	"Nehemiah",
	"Esther",
	"Job",
	"Psalms",
	"Proverbs",
	"Ecclesiastes",
	"Solomon's Song",
	"Isaiah",
	"Jeremiah",
	"Lamentations",
	"Ezekiel",
	"Daniel",
	"Hosea",
	"Joel",
	"Amos",
	"Obadiah",
	"Jonah",
	"Micah",
	"Nahum",
	"Habakkuk",
	"Zephaniah",
	"Haggai",
	"Zechariah",
	"Malachi",
}
local bofm = {
	"1 Nephi",
	"2 Nephi",
	"Jacob",
	"Enos",
	"Jarom",
	"Omni",
	"Words of Mormon",
	"Mosiah",
	"Alma",
	"Helaman",
	"3 Nephi",
	"4 Nephi",
	"Mormon",
	"Ether",
	"Moroni",
}

local dnc = {
	"Doctrine and Covenants",
}
local pgp = {
	"Moses",
	"Abraham",
	"Joseph Smith--Matthew",
	"Joseph Smith--History",
	"Articles of Faith",
}

local function contains(table, element)
	for _, value in ipairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

local function get_short_volume_name(book)
	if contains(newtestament, book) then
		return "nt"
	elseif contains(oldtestament, book) then
		return "ot"
	elseif contains(pgp, book) then
		return "pgp"
	elseif contains(bofm, book) then
		return "bofm"
	elseif contains(dnc, book) then
		return "dc-testament"
	end
end

local short_books = {
	["Genesis"] = "gen",
	["Exodus"] = "ex",
	["Leviticus"] = "lev",
	["Numbers"] = "num",
	["Deuteronomy"] = "deut",
	["Joshua"] = "josh",
	["Judges"] = "judg",
	["Ruth"] = "ruth",
	["1 Samuel"] = "1-sam",
	["2 Samuel"] = "2-sam",
	["1 Kings"] = "1-kgs",
	["2 Kings"] = "2-kgs",
	["1 Chronicles"] = "1-chr",
	["2 Chronicles"] = "2-chr",
	["Ezra"] = "ezra",
	["Nehemiah"] = "neh",
	["Esther"] = "esth",
	["Job"] = "job",
	["Psalms"] = "ps",
	["Proverbs"] = "prov",
	["Ecclesiastes"] = "eccl",
	["Solomon's Song"] = "song",
	["Isaiah"] = "isa",
	["Jeremiah"] = "jer",
	["Lamentations"] = "lam",
	["Ezekiel"] = "ezek",
	["Daniel"] = "dan",
	["Hosea"] = "hosea",
	["Joel"] = "joel",
	["Amos"] = "amos",
	["Obadiah"] = "obad", -- only one chapter
	["Jonah"] = "jonah",
	["Micah"] = "micah",
	["Nahum"] = "nahum",
	["Habakkuk"] = "hab",
	["Zephaniah"] = "zeph",
	["Haggai"] = "hag",
	["Zechariah"] = "zech",
	["Malachi"] = "mal",
	["Matthew"] = "matt",
	["Mark"] = "mark",
	["Luke"] = "luke",
	["John"] = "john",
	["Acts"] = "acts",
	["Romans"] = "rom",
	["1 Corinthians"] = "1-cor",
	["2 Corinthians"] = "2-cor",
	["Galatians"] = "gal",
	["Ephesians"] = "eph",
	["Philippians"] = "philip",
	["Colossians"] = "col",
	["1 Thessalonians"] = "1-thes",
	["2 Thessalonians"] = "2-thes",
	["1 Timothy"] = "1-tim",
	["2 Timothy"] = "2-tim",
	["Titus"] = "titus",
	["Philemon"] = "philem", -- There's an exception with philemon. the URL must end in /1
	["Hebrews"] = "heb",
	["James"] = "james",
	["1 Peter"] = "1-pet",
	["2 Peter"] = "2-pet",
	["1 John"] = "1-jn",
	["2 John"] = "2-jn", -- also only one chapter.
	["3 John"] = "3-jn", -- also
	["Jude"] = "jude", -- also
	["Revelation"] = "rev",
	["1 Nephi"] = "1-ne",
	["2 Nephi"] = "2-ne",
	["Jacob"] = "jacob",
	["Enos"] = "enos",
	["Jarom"] = "jarom",
	["Omni"] = "omni",
	["Words of Mormon"] = "w-of-m",
	["Mosiah"] = "mosiah",
	["Alma"] = "alma",
	["Helaman"] = "hel",
	["3 Nephi"] = "3-ne",
	["4 Nephi"] = "3-ne",
	["Mormon"] = "morm",
	["Ether"] = "ether",
	["Moroni"] = "moro",
	["Doctrine and Covenants"] = "dc",
	["Official Declaration 1"] = "od",
	["Official Declaration 2"] = "od",
	["Moses"] = "moses",
	["Abraham"] = "abr",
	["Joseph Smith--Matthew"] = "js-m",
	["Joseph Smith--History"] = "js-h",
	["Articles of Faith"] = "a-of-f",
}

local scripture = { "bofm", "ot", "nt", "dc-testament", "pgp" }

local M = {}
-- Function to remove HTML tags

local function remove_html_tags(str)
	return str:gsub("<.->", "")
end
-- Function to extract paragraphs
local function extract_paragraphs(html)
	local paragraphs = {}
	for p_tag in html:gmatch('<p class=\\"verse\\".-</p>') do
		local verse_number = strip(p_tag:match('<span class=\\"verse%-number\\">(.-)</span>') or "")
		local verse_text = p_tag:gsub('<span class=\\"verse%-number\\">.-</span>', ""):match('">(.-)</p>') or ""
		-- Remove additional HTML tags from verse text
		verse_text = remove_html_tags(verse_text)
		paragraphs[verse_number] = verse_text
	end
	return paragraphs
end

local function insert_verses(versestable, reference)
	local keys = {}
	for key in pairs(versestable) do
		table.insert(keys, key)
	end

	-- Step 2: Sort the list of keys
	table.sort(keys)
	local text = {}
	-- Step 3: Iterate over the sorted list to access the values
	for _, key in ipairs(keys) do
		-- print("Key:", key, "Value:", versestable[key])
		table.insert(text, tostring(key) .. ". " .. versestable[key])
	end
	local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
	vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, text)
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
		local short_book = short_books[book]
		local url = string.format(
			"https://www.churchofjesuschrist.org/study/api/v3/language-pages/type/content?lang=%s&uri=/scriptures/%s/%s/%s",
			language,
			short_volume,
			short_book,
			chapter
		)
		print(url)
		local result = curl.get(url)

		-- Check if the request was successful
		if result.status ~= 200 then
			print("Failed to fetch data from the URL. Status code:", result.status)
		else
			local body = result.body
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
				print("Empty verses table. will get all of them.")
				verses_to_insert = all_verses
			else
				for _, verse in ipairs(verses) do
					print(verse, paragraphs[verse])
					verses_to_insert[tonumber(verse)] = paragraphs[verse]
				end
			end
			insert_verses(verses_to_insert, reference)
		end
	end
end

return M
