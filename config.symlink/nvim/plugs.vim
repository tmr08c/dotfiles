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


" working with make and quickfix
" dispatch helps neomake know what compiler to use for vim-test
Plug 'tpope/vim-dispatch'

Plug 'neomake/neomake'
" remove special characters for space and newline characters
" https://github.com/neomake/neomake/issues/2459
let g:neomake_postprocess = 'neomake#postprocess#compress_whitespace'

" listen for hooks 
augroup neomake_hook
  au!
  autocmd User NeomakeJobFinished call TestFinished()
  autocmd User NeomakeJobStarted call TestStarted()
augroup END

" Test status based on Neomake status
"
" Thanks to https://www.dev-log.me/Running_tests_with_vim-test/
"
" This assumes that **all** neomake jobs are related to testing which isn't
" necessarily true. We may be able to check the context and guess, but tere
" doesn't seem to be a clear way to tell.

" initially empty status
let g:testing_status = ''

" Set status that tests are starting
function! TestStarted() abort
  let g:testing_status = 'Test ⌛'
endfunction

" Set status when tests are done
function! TestFinished() abort
  let context = g:neomake_hook_context

  if context.jobinfo.exit_code == 0
    let g:testing_status = 'Test ✅'
  endif

  if context.jobinfo.exit_code == 1
    let g:testing_status = 'Test ❌'
  endif
endfunction

function! TestStatus() abort
  return g:testing_status
endfunction

" =================
" </General>
" =================



" =================
" <Style>
" =================

" load a bunch of colorschems to choose from
Plug 'flazz/vim-colorschemes' 

Plug 'itchyny/lightline.vim'
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'teststatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'teststatus': 'TestStatus'
      \ },
      \ }

" There's no built-in way to reload to allow for colorscheme changes
" This function can be called to reload lightline and is used a part of my
" light and dark mode functions
"
" From https://github.com/itchyny/lightline.vim/pull/259
function! ReloadLightLine()
  :call lightline#init()
  :call lightline#colorscheme()
  :call lightline#update()
endfunction

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

" ruby
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'tpope/vim-rake', { 'for': 'ruby' } " like vim-rails, for non rails projects
Plug 'tpope/vim-rails', { 'for': 'ruby' }

" testing
Plug 'janko/vim-test', { 'on': ['TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit'] }

let test#strategy = "neomake"
nmap <leader>tt :TestNearest<CR>
" run a single test and get full output in terminal 
nmap <leader>tT :TestNearest -strategy=neovim<CR>
nmap <leader>tf :TestFile<CR>
nmap <leader>ta :TestSuite<CR>
nmap <leader>tl :TestLast<CR>
nmap <leader>tv :TestVisit<CR>

" Intellisense
Plug 'neoclide/coc.nvim', {'branch': 'release'}


" =================
" </Programming>
" =================

call plug#end()
