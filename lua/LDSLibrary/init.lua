local scriptquery = require("LDSLibrary.utils.scripturequery")

local parser = require("LDSLibrary.utils.parser")

local M = {}

---@param opts? table
M.setup = function(opts)
	opts = opts or { language = "eng",
					debub = false }

	local function myfunc(args)
		local input = args.args
		local queries = parser.parse(input, opts)
		scriptquery.scripturequery(queries, opts)
	end

	local function load()
		vim.api.nvim_create_user_command("MC", myfunc, { nargs = 1 })
	end
	load()
end

return M
