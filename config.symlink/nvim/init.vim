set nocompatible " be iMproved, required

" Plugins
"Load Vundle config
if filereadable(expand("~/.config/nvim/plugs.vim"))
  source ~/.config/nvim/plugs.vim
endif

" General
"
" Customize keybindings
let mapleader="\<SPACE>"

" Generally configure tabs to 2, and convert to spaces
set tabstop=2
set backspace=2
set softtabstop=2
set expandtab
set shiftwidth=2
set shiftround
set nojoinspaces

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


" t(theme)
nmap <leader>vtl :call LightMode()<CR>
nmap <leader>vtd :call DarkMode()<CR>

" end v(im) section

" ==========================
" Working with fzf
" ==========================

" files in current project
nmap <leader>pf :Files<CR>

" project wide search 
if executable('rg')
  nmap <leader>/ :Rg<CR>
elseif executable('ag')
  nmap <leader>/ :Ag<CR>
endif

" show vim buffers
nmap <leader>bb :Buffers<CR>
nmap <leader>bd :bdelete<CR>
nmap <leader>bn :bnext<CR>
nmap <leader>bp :bprevious<CR>
" End fzf section
