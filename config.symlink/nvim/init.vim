set nocompatible " be iMproved, required

" Leader key needs to be set early, so we can use it later
let mapleader="\<SPACE>"

" Plugins
"Load Vundle config
if filereadable(expand("~/.config/nvim/plugs.vim"))
  source ~/.config/nvim/plugs.vim
endif

" General
"
" Customize keybindings

" Generally configure tabs to 2, and convert to spaces
set tabstop=2
set backspace=2
set softtabstop=2
set expandtab
set shiftwidth=2
set shiftround
set nojoinspaces

" Search

" default to being case insensitive
set ignorecase
" worry about case when including a capital letter
set smartcase

" Splits/Windows

" make it easier to move between splits/windows
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" it seems that it's more natural to expect splits to open in this way
set splitbelow
set splitright

" Style

syntax on
filetype on

" set Vim-specific sequences for RGB colors
" https://tomlankhorst.nl/iterm-tmux-vim-true-color/
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

function! LightMode()
  set background=light
  colorscheme Tomorrow

  " lightline
  let g:lightline.colorscheme = 'Tomorrow'
  :call ReloadLightLine()
endfunction

function! DarkMode()
  set background=dark
  colorscheme Tomorrow-Night-Eighties

  " lightline
  let g:lightline.colorscheme = 'Tomorrow_Night_Eighties'
  :call ReloadLightLine()
endfunction

" Default color mode based on system settings
if system('darkMode') =~ "Dark"
  :call DarkMode()
else
  :call LightMode()
endif


set number relativenumber

" Terminal

" let escape take us into normal mode
:tnoremap <Esc> <C-\><C-n>


" ==========================
" Leader key settings
" ==========================

" f(ile)
nmap <leader>fs :write<CR>

" v(im)

" e(dit) config
nmap <leader>ve :vsplit $MYVIMRC<CR>

" r(eload) config
nmap <leader>vr :source $MYVIMRC<CR>

" s(earch)
" (c) clear
nmap <leader>sc :nohl<CR>

" t(theme)
nmap <leader>vtl :call LightMode()<CR>
nmap <leader>vtd :call DarkMode()<CR>

" end v(im) section

" ==========================
" Working with fzf
" ==========================

" files in current "project" (based on git)
nmap <leader>pf :<C-u>GFiles<CR>
nmap <leader>pF :<C-u>Files<CR>
" files from home directory
nmap <leader>ff :<C-u>Files ~/<CR>

" project wide search
nmap <leader>/ :<C-u>Rg<CR>

" show vim buffers
nmap <leader>bb :<C-u>Buffers<CR>
nmap <leader>bd :bdelete<CR>
nmap <leader>bn :bnext<CR>
nmap <leader>bp :bprevious<CR>
" End fzf section

" ==========================
" Config for file types
" ==========================

" json

" json comment highlighting
autocmd FileType json syntax match Comment +\/\/.\+$+
