call plug#begin()
" List your plugins here

"Plug 'neoclide/coc.nvim', {'branch': 'release'}

"""""" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
"""""" Telescope

"""""" Themes
"Plug 'nyoom-engineering/nyoom.nvim'
Plug 'joshdick/onedark.vim'
Plug 'rebelot/kanagawa.nvim'
Plug 'slugbyte/lackluster.nvim'
"""""" Themes

"""""" StatusBar
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
"""""" StatusBar

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

"syntax on
colorscheme onedark
"colorscheme habamax
"colorscheme kanagawa-dragon "para dia
"colorscheme lackluster-dark "para noite

"filetype plugin indent on
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

""""""""""""""""""" Telescope

"nnoremap <leader>ff <cmd>Telescope git_files<cr>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fs <cmd>Telescope grep_string<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>gd <cmd>Telescope lsp_definitions<cr>
nnoremap <leader>gi <cmd>Telescope lsp_implementations<cr>
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
		theme = 'iceberg',
		section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_a = {'getMode()', 'diagnostics'},
		lualine_b = {'branch', 'diff'},
        lualine_c = {'filename'},
        lualine_x = {'searchcount', 'filetype'},
        lualine_z = {'location'}
    },
}
END

""""""""""""""""""" StatusBar

""""""""""""""""""" treesitter
lua << END
require('nvim-treesitter.configs').setup {
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
	sync_install = false,
	auto_install = false,
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
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'ts_ls', 'vuels', 'csharp_ls' }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- LSP: pyright
--require('lspconfig').pyright.setup {
--
--}

-- LSP: ts_ls
require('lspconfig').ts_ls.setup {

}

-- LSP: vuels
require('lspconfig').vuels.setup {}

-- LSP: csharp_ls
require('lspconfig').csharp_ls.setup {}

END
""""""""""""""""""" LSP
