local M = {}

-- mode
M.mode = function()
	local modes = {
		n = "NORMAL",
		i = "INSERT",
		v = "VISUAL",
		V = "V-LINE",
		["\22"] = "V-BLOCK",
		c = "CMD",
		R = "REPLACE",
	}
	return modes[vim.fn.mode()] or vim.fn.mode()
end

-- git branch (dùng git command, không plugin)
M.git_branch = function()
	local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
	if branch ~= "" then
		return " " .. branch
	end
	return ""
end

-- diagnostics
M.diagnostics = function()
	local bufnr = 0
	local levels = {
		{ vim.diagnostic.severity.ERROR, "" },
		{ vim.diagnostic.severity.WARN, "" },
		{ vim.diagnostic.severity.INFO, "" },
		{ vim.diagnostic.severity.HINT, "󰠠" },
	}

	local out = {}
	for _, level in ipairs(levels) do
		local count = #vim.diagnostic.get(bufnr, { severity = level[1] })
		if count > 0 then
			table.insert(out, level[2] .. ":" .. count)
		end
	end

	return table.concat(out, " ")
end

return M
