local function organize_tasks()
	local buf = 0
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	------------------------------------------------------------------
	-- 1. Tách frontmatter
	------------------------------------------------------------------
	local frontmatter = {}
	local body_start = 1
	if lines[1] == "---" then
		table.insert(frontmatter, "---")
		for i = 2, #lines do
			table.insert(frontmatter, lines[i])
			if lines[i] == "---" then
				body_start = i + 1
				break
			end
		end
	end
	------------------------------------------------------------------
	-- 2. Tách kanban comment (%% ... %% ở cuối)
	------------------------------------------------------------------
	local body = {}
	local kanban = {}
	local kanban_start
	for i = body_start, #lines do
		if lines[i]:match("^%%%%") then
			kanban_start = i
			break
		end
		table.insert(body, lines[i])
	end
	if kanban_start then
		for i = kanban_start, #lines do
			table.insert(kanban, lines[i])
		end
	end
	------------------------------------------------------------------
	-- 3. Phân loại task blocks (task chính + subtask)
	------------------------------------------------------------------
	local backlog, working, done = {}, {}, {}
	local i = 1
	while i <= #body do
		local line = body[i]
		if line:match("^%- %[.%]") then
			local block = { line }
			local j = i + 1
			while j <= #body do
				local next_line = body[j]
				if next_line:match("^%- %[.%]") then
					break
				end
				if next_line == "" or next_line:match("^%s+") then
					table.insert(block, next_line)
					j = j + 1
				else
					break
				end
			end
			if line:match("^%- %[ %]") then
				table.insert(backlog, block)
			elseif line:match("^%- %[%-]") then
				table.insert(working, block)
			elseif line:match("^%- %[x%]") then
				table.insert(done, block)
			end
			i = j
		else
			i = i + 1
		end
	end
	------------------------------------------------------------------
	-- 4. Build output (LINE-BASED ONLY)
	------------------------------------------------------------------
	local result = {}
	local function add_section(title, blocks)
		-- CHANGED: Always add the heading, regardless of whether there are blocks
		table.insert(result, title)
		table.insert(result, "")
		-- Add blocks if they exist
		for _, block in ipairs(blocks) do
			for _, l in ipairs(block) do
				table.insert(result, l)
			end
		end
	end
	-- frontmatter
	for _, l in ipairs(frontmatter) do
		table.insert(result, l)
	end
	if #frontmatter > 0 then
		table.insert(result, "")
	end
	add_section("# Back log", backlog)
	add_section("# Working in progress", working)
	add_section("# Done", done)
	-- remove trailing empty line
	while result[#result] == "" do
		table.remove(result)
	end
	-- kanban comment
	if #kanban > 0 then
		table.insert(result, "")
		for _, l in ipairs(kanban) do
			table.insert(result, l)
		end
	end
	------------------------------------------------------------------
	-- 5. Write buffer
	------------------------------------------------------------------
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, result)
	print("Tasks organized successfully!")
end
vim.api.nvim_create_user_command("OrganizeTasks", organize_tasks, {})
return organize_tasks
