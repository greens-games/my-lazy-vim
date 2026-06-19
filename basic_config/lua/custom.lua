vim.keymap.set('v', '<leader>when', function ()
	local v = vim.fn.getpos('v')
	local dot = vim.fn.getpos('.')
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	print("v: ", v[2],"dot: ", dot[2])
	
	local start_row = 0
	local end_row = 0
	if v[2] < dot[2] then 
		start_row = v[2]
		end_row = dot[2]
	else
		start_row = dot[2]
		end_row = v[2]
	end

	vim.api.nvim_buf_set_lines(0, start_row - 1, start_row - 1, true, {"when 1 == 0 {"})
	vim.api.nvim_buf_set_lines(0, end_row + 1, end_row + 1, true, {"}"})
	-- move cursor down 1
	vim.fn.cursor(end_row + 2, 0)
	-- auto ident
end)
