local M = {}

function M.strip(inputstr)
	return (inputstr:gsub("^%s*(.-)%s*$", "%1"))
end

function M.split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		str = M.strip(str)
		table.insert(t, str)
	end
	return t
end


return M