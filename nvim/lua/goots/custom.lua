local function get_start ()

	local v = vim.fn.getpos('v')
	local dot = vim.fn.getpos('.')
	
	local start_row = 0
	if v[2] < dot[2] then 
		start_row = v[2]
	else
		start_row = dot[2]
	end

	return start_row

end

local function get_end ()

	local v = vim.fn.getpos('v')
	local dot = vim.fn.getpos('.')
	
	local end_row = 0
	if v[2] < dot[2] then 
		end_row = dot[2]
	else
		end_row = v[2]
	end

	return end_row

end

vim.keymap.set('v', '<leader>when', function ()

	local start_row = get_start()
	local end_row = get_end()

	vim.api.nvim_buf_set_lines(0, start_row - 1, start_row - 1, true, {"when 1 == 0 {"})
	vim.api.nvim_buf_set_lines(0, end_row + 1, end_row + 1, true, {"}"})
	-- move cursor down 1
	vim.fn.cursor(end_row + 2, 0)
	-- auto ident
end)

vim.keymap.set('v', '<C-j>', function ()
	local start_row = get_start()
	local end_row = get_end()

	local num_lines = (end_row - start_row) + 1
	local val = "+" .. tostring(num_lines)
	vim.cmd.move(val)
end)

