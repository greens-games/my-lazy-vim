require('goots.remap')
require('goots.custom')


local function package(org, repo)
	return 'https://github.com/' .. org .. '/' .. repo
end

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})


-- vim.pack.add{'https://github.com/neovim/nvim-lspconfig'}
vim.pack.add{
	package('folke', 'which-key.nvim'),
	package('numToStr', 'Comment.nvim'),
}

--Colour schemes
vim.pack.add{
	package('luisiacc', 'gruvbox-baby'),
}

vim.cmd.colorscheme 'gruvbox-baby'
-- transparent background
vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none"})
-- You can configure highlights by doing something like
-- vim.cmd.hi 'Comment gui=none'

-- Telescope
vim.pack.add{
	package('nvim-lua', 'plenary.nvim'),
    package('nvim-telescope', 'telescope-fzf-native.nvim'),
    package('nvim-telescope', 'telescope-ui-select.nvim'),
	package('nvim-telescope', 'telescope.nvim')
}

require('telescope').setup {
	extensions = {
		['ui-select'] = {
			require('telescope.themes').get_dropdown(),
		},
	},
}

pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })

vim.keymap.set('n', '<leader>/', function()
	builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
		previewer = false,
	})
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>s/', function()
	builtin.live_grep {
		grep_open_files = true,
		prompt_title = 'Live Grep in Open Files',
	}
end, { desc = '[S]earch [/] in Open Files' })

vim.keymap.set('n', '<leader>sn', function()
	builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })

--LSP
vim.pack.add{ 
	package('hrsh7th', 'nvim-cmp'),
	package('hrsh7th', 'cmp-nvim-lsp'),
	package('hrsh7th', 'cmp-path'),
	package('nvim-mini', 'mini.nvim'),
	package('neovim', 'nvim-lspconfig'),
	package('mason-org', 'mason.nvim'),
}
require('mason').setup()

vim.diagnostic.config({ virtual_text = true })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())

vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.enable('lua_ls')
vim.lsp.enable('clangd')
vim.lsp.enable('ols')
local cmp = require 'cmp'
cmp.setup {
	completion = { completeopt = 'menu,menuone,noinsert' },
	mapping = cmp.mapping.preset.insert {
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<Tab>'] = cmp.mapping.confirm { select = true },
		['<C-Space>'] = cmp.mapping.complete {},
	},

	--Sets up compleion menu
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'path' },
	},
}

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {desc = "Go to def"})

vim.pack.add({
 { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
})

local ensure_installed = {
	"odin",
}

require('nvim-treesitter').install(ensure_installed)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		local buf = args.buf
		local ft = vim.bo[buf].filetype

		local lang = vim.treesitter.language.get_lang(ft)
		if not lang then
			return
		end

		local ok_add = pcall(vim.treesitter.language.add, lang)
		if not ok_add then
			return
		end

		pcall(vim.treesitter.start, buf, lang)
	end,
})
