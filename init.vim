call plug#begin()
" List your plugins here

Plug 'neoclide/coc.nvim', {'branch': 'release'}

"""""" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
"""""" Telescope

"""""" Themes
"Plug 'nyoom-engineering/nyoom.nvim'
Plug 'joshdick/onedark.vim'
Plug 'rebelot/kanagawa.nvim'
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
set list listchars+=space:. listchars-=eol:$

"syntax on
"colorscheme onedark
"colorscheme habamax
colorscheme kanagawa-dragon

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

""""""""""""""""""" COC

set signcolumn=yes

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

nnoremap <leader>ii <cmd>CocCommand editor.action.formatDocument<cr>
nnoremap <leader>rr <cmd>CocCommand document.renameCurrentWord<cr>
nnoremap <leader>rn <Plug>(coc-rename)
nnoremap <leader>gr <Plug>(coc-references)
nnoremap <leader>gi <Plug>(coc-implementation)
nnoremap <leader>gy <Plug>(coc-type-definition)
nnoremap <leader>gd <Plug>(coc-definition)

" do workspace
" nnoremap <leader>s <cmd>CocList -I symbols<cr> 

" do buffer
nnoremap <leader>s <cmd>CocList outline<cr>

" abre outline na direita
nnoremap <leader>o <cmd>CocOutline<cr>
nnoremap <leader>d <cmd>CocList diagnostics<cr>

""""""""""""""""""" COC

""""""""""""""""""" Diffview

nnoremap <leader>do <cmd>DiffviewOpen<cr>
nnoremap <leader>dc <cmd>DiffviewClose<cr>

""""""""""""""""""" Diffview

""""""""""""""""""" Telescope
"nnoremap <leader>ff <cmd>Telescope git_files<cr>
"sem o ignore aparece TUDO
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fs <cmd>Telescope grep_string<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

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

""""""""""""""""""" StatusBar
" filename ou %f

lua << END
require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = 'iceberg_dark'
    },
    sections = {
        lualine_a = {'mode'},
		lualine_b = {'branch', 'diff'},
        lualine_d = {'%f'},
        lualine_x = {'encoding', 'filetype'},
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
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'ts_ls', 'vuels', 'pyright', 'csharp_ls' }

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
END
""""""""""""""""""" LSP

""""""""""""""""""" LSP: pyright
lua << END
require('lspconfig').pyright.setup {

}
END
""""""""""""""""""" LSP: pyright

""""""""""""""""""" LSP: ts_ls
lua << END
require('lspconfig').ts_ls.setup {
	filetypes = {
		"javascript",
		"typescript",
		"vue",
	},

}
END
""""""""""""""""""" LSP: ts_ls

""""""""""""""""""" LSP: vuels
lua << END
require('lspconfig').vuels.setup {

}
END
""""""""""""""""""" LSP: vuels

""""""""""""""""""" LSP: csharp_ls
lua << END
require('lspconfig').csharp_ls.setup {

}
END
""""""""""""""""""" LSP: csharp_ls
