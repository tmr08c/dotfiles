" install vim-plug if needed.
" stolen from https://github.com/dbernheisel/dotfiles/blob/master/.config/nvim/init.vim
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Initialize plugin system
call plug#begin(stdpath('data') . '/plugged')

" Make sure you use single quotes

" =================
" <General>
" =================

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'


" fzf is used for file-finding and various other fuzzy finding windows
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" =================
" </General>
" =================



" =================
" <Style>
" =================

" load a bunch of colorschems to choose from
Plug 'flazz/vim-colorschemes' 

" =================
" </Style>
" =================



" =================
" <Programming>
" =================

" all language plugins
"
" this allows syntax higlighting for files as-needed 
" it is reccommend to add language-specific plugins for 
" languages that are most commonly worked with
Plug 'sheerun/vim-polyglot'

" Intellisense
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" ruby
Plug 'vim-ruby/vim-ruby'

" =================
" </Programming>
" =================

call plug#end()
