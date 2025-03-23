call plug#begin()
" List your plugins here

"Plug 'neoclide/coc.nvim', {'branch': 'release'}

"""""" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
"""""" Telescope

"""""" Themes
Plug 'joshdick/onedark.vim'
Plug 'rebelot/kanagawa.nvim'
Plug 'slugbyte/lackluster.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'vague2k/vague.nvim'
"""""" Themes

"""""" StatusBar
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
"""""" StatusBar

" scope lines
Plug 'lukas-reineke/indent-blankline.nvim'

"" Git diff view
Plug 'sindrets/diffview.nvim'

"" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

"" LSP
Plug 'neovim/nvim-lspconfig'

" Autocompletion plugin
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'

" some snippets
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'

call plug#end()

let mapleader="\<space>"

set number
set ruler
set cursorline
set relativenumber
set colorcolumn=90
"set list listchars+=space:. listchars-=eol:$
set signcolumn=yes

"set background=dark
colorscheme vague
"colorscheme onedark
"colorscheme habamax
"colorscheme lackluster-dark
"colorscheme kanagawa-dragon

set tabstop=4
set shiftwidth=4
set expandtab
"set modelines=0

nmap <leader>b :ls<CR>
nmap <leader>] :bn<CR>
nmap <leader>[ :bp<CR>
nmap <leader>> :tabnext<CR>
nmap <leader>< :tabprevious<CR>
nmap <leader>e :Ntree<CR>

nmap <leader>a <cmd>lua vim.lsp.buf.code_action()<cr>
nmap <leader>h <cmd>lua vim.lsp.buf.clear_references(); vim.lsp.buf.document_highlight()<cr>
nmap <leader>rr <cmd>lua vim.lsp.buf.rename()<cr>
"nmap <leader>gr <cmd>lua vim.lsp.buf.references()<cr>
inoremap <C-d> <cmd>lua vim.lsp.buf.signature_help()<cr>

""" para mover linha(s)

nnoremap <A-Down> :m+<CR>==
nnoremap <A-Up> :m-2<CR>==
inoremap <A-Down> <Esc>:m+<CR>==gi
inoremap <A-Up> <Esc>:m-2<CR>==gi
vnoremap <A-Down> :m'>+<CR>gv=gv
vnoremap <A-Up> :m-2<CR>gv=gv

""" para mover linha(s)

""""""""""""""""""" Telescope
"nnoremap <leader>ff <cmd>Telescope git_files<cr>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fs <cmd>Telescope grep_string<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>

nnoremap <leader>gi <cmd>Telescope lsp_implementations<cr>
nnoremap <leader>gd <cmd>Telescope lsp_definitions<cr>
nnoremap <leader>gr <cmd>Telescope lsp_references<cr>

nnoremap <leader>s <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader>d <cmd>Telescope diagnostics<cr>
nnoremap <leader>t <cmd>Telescope treesitter<cr>

"lua << EOF
"require('telescope').setup {
"   defaults = {
"       file_ignore_patterns = {
"         "node_modules/*", "%.git/*"
"       },
"   }
"}
"EOF
""""""""""""""""""" Telescope

""""""""""""""""""" Diffview

nnoremap <leader>do <cmd>DiffviewOpen<cr>
nnoremap <leader>dc <cmd>DiffviewClose<cr>

""""""""""""""""""" Diffview

""""""""""""""""""" StatusBar
" filename ou %f
" fileformat ou filetype

lua << END

function getMode()
	local mode_info = vim.api.nvim_get_mode()
    return string.upper(mode_info.mode)
end

require('lualine').setup {
    options = {
        icons_enabled = false,
		section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_a = {'getMode()'},
		lualine_b = {'branch', 'diff'},
        lualine_c = {'diagnostics', 'filename'},
        lualine_x = {'filetype'}
    },
}
END

""""""""""""""""""" StatusBar

""""""""""""""""""" treesitter
lua << END
require('nvim-treesitter.configs').setup {
	ensure_installed = { "cpp", "c", "rust", "lua", "vim", "javascript", "typescript" },
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	additional_vim_regex_highlighting = false,
}
END
""""""""""""""""""" treesitter

""""""""""""""""""" LSP
lua << END

-- Specify how the border looks like
local border = {
    { '┌', 'FloatBorder' },
    { '─', 'FloatBorder' },
    { '┐', 'FloatBorder' },
    { '│', 'FloatBorder' },
    { '┘', 'FloatBorder' },
    { '─', 'FloatBorder' },
    { '└', 'FloatBorder' },
    { '│', 'FloatBorder' },
}

-- Add the border on hover and on signature help popup window
local handlers = {
    ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
    ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')

-- para ver capabilities
-- :lua =vim.lsp.get_clients()[1].server_capabilities  

local servers = {'csharp_ls', 'vuels', 'ts_ls', 'clangd', 'pyright'}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup {
		handlers = handlers,
		capabilities = capabilities,
	}
end

lspconfig.rust_analyzer.setup {
	handlers = handlers,
	capabilities = capabilities,
	settings = {
		['rust-analyzer'] = {
			diagnostics = {
				enable = false;
			}
		}
	}
}

-- luasnip setup
local luasnip = require 'luasnip'

-- custom snippets 
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

local js_files = { 'javascript', 'typescript', 'vue' }

for _, filetype in ipairs(js_files) do
	luasnip.add_snippets(filetype, {
		s("clg", {
			t('console.log('), i(1), t(')')
		})
	})

	luasnip.add_snippets(filetype, {
		s("tryc", {
			t("try {"),
			t({"", "  "}), i(1, "// try body"), 
			t({"", "} catch ("}), i(2, "error"), t(") {"),
			t({"", "  "}), i(3, "// catch body"), 
			t({"", "}"})
		})
	})
end

-- nvim-cmp setup
local cmp = require 'cmp'

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end),
		['<CR>'] = cmp.mapping.confirm { select = true },
		['<C-Space>'] = cmp.mapping.complete(),
	}),
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
}

END

""""""""""""""""""" LSP

""""""""""""""""""" scope lines
"lua << END
"
"require('ibl').setup {
"   -- scope = { enabled = false },
"}
"
"END

""""""""""""""""""" scope lines
