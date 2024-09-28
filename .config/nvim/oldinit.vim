call plug#begin()
Plug 'elkowar/yuck.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lervag/vimtex'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'MunifTanjim/nui.nvim'

Plug 'BurntSushi/ripgrep'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'

Plug 'folke/tokyonight.nvim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

Plug 'akinsho/toggleterm.nvim'

Plug 'Civitasv/cmake-tools.nvim'

call plug#end()

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
set number
highlight LineNr ctermfg=darkgrey

set tabstop=4
set shiftwidth=4
set expandtab
let g:airline_theme = 'catppuccin'
colorscheme catppuccin-mocha

nmap <C-tab> :Neotree<CR>

set updatetime=300

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

nmap <C-f> :Telescope current_buffer_fuzzy_find<CR>
nmap <C-n> :Telescope fd<CR>
nmap <C-b> :Telescope buffers<CR>
nmap <C-g> :Telescope live_grep<CR>
nmap <C-CR> :Telescope grep_string<CR>

set guifont=Fira\ Code:h12
let g:neovide_scroll_animation_far_lines = 1

lua require("toggleterm").setup()
let g:neovide_transparency = 0.9
