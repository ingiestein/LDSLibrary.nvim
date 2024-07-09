local fuzzy_matcher = require("LDSLibrary.utils.fuzzy_matcher")
local gf = require("LDSLibrary.utils.global_functions")

local M = {}

local debug = false

local function rangeToList(rangeStr)
	local startNum, endNum = rangeStr:match("(%d+)-(%d+)")
	startNum = tonumber(startNum)
	endNum = tonumber(endNum)

	if not startNum or not endNum then
		return { rangeStr }
	end

	local result = {}
	for i = startNum, endNum do
		table.insert(result, tostring(i))
	end

	return result
end

local function extract_book_names(input)
	return input:match("([1-4]?%s?[A-za-z ]+)")
end

local function split_chapter_verse(input)
	local splitinput = gf.split(input, ":")
	if #splitinput == 0 then
		print("no chapter/verse found")
		return {
			chapter = nil,
			verses = nil,
		}
	elseif #splitinput == 1 then
		local chapter = splitinput[1]
		return {
			chapter = chapter,
			verses = nil,
		}
	elseif #splitinput == 2 then
		local chapter = splitinput[1]
		local verses = splitinput[2]
		return {
			chapter = chapter,
			verses = verses,
		}
	else
		return {
			chapter = nil,
			verses = nil,
		}
	end
end

local function extract_verses(input, booktitle)
	local numbers = {}
	local seen = {}
	local versestring = gf.strip(input:gsub(booktitle, ""))
	local result = split_chapter_verse(versestring)
	local chapter = result.chapter
	local verses = result.verses
	if debug then
		print("extract_verses chapter: ", vim.inspect(chapter))
		print("extract_verses verses: ", vim.inspect(verses))
	end

	if verses then
		local verse_groups = gf.split(verses, ",")
		if debug then
			print("extract_verses verse_groups: ", vim.inspect(verse_groups))
		end
		for _, verse in ipairs(verse_groups) do
			local versenums = rangeToList(verse)
			if debug then
				print("extract_verses versenums: ", vim.inspect(versenums))
			end
			for _, num in ipairs(versenums) do
				if not seen[num] then
					table.insert(numbers, num)
					seen[num] = true
				end
			end
		end
	end

	return {
		chapter = chapter,
		verses = numbers,
	}
end

-- Function to start the fuzzy finder and parse input
function M.parse(input, opts)
	local opts = opts
	-- print(input)
	local splitinput = gf.split(input, ";")

	local querytable = {}
	for _, ref in ipairs(splitinput) do
		local booktitle = extract_book_names(ref)
		local chapter_verses = extract_verses(ref, booktitle)
		local fuzybooktitle = fuzzy_matcher.find_best_match(gf.strip(booktitle))
		local chapter = chapter_verses.chapter
		local verses = chapter_verses.verses
		if debug then
			print("Ref: ", vim.inspect(ref))
			print("Book Title: ", vim.inspect(booktitle))
			print("Fuzzy Title: ", vim.inspect({ fuzybooktitle }))
			print("Chapter: ", vim.inspect(chapter))
			print("Verses: ", vim.inspect(verses))
		end
		local referencedata = {
			book = fuzybooktitle,
			in_language_title = nil,
			chapter = chapter,
			verses = verses,
		}
		table.insert(querytable, referencedata)
	end

	return querytable
end

return M
