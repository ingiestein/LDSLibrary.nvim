local levenshtein = require("LDSLibrary.utils.Levenshtein")
local lib = require("LDSLibrary.tables.scripturetables")

local M = {}

-- List of expected book names

-- Function to find the best match for a given input
function M.find_best_match(input)
	local best_match = nil
	local lowest_score = math.huge -- Use math.huge to initialize to + infinity

	for _, book in ipairs(lib.books) do
		local score = levenshtein(book, input)
		-- print(score, book, input)
		if score < lowest_score then
			lowest_score = score
			best_match = book
		end
	end

	return best_match
end

return M
