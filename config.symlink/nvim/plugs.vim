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
" use floating window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" highlight (and have the ability to remove) trailing whitespace
Plug 'ntpeters/vim-better-whitespace'

" default to stripping whitespace on save
let g:strip_whitespace_on_save = 1
" only strip lines we've modified
let g:strip_only_modified_lines = 1
" don't prompt to confirm when stripping
let g:strip_whitespace_confirm = 0

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
      \             [ 'teststatus', 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'teststatus': 'TestStatus',
      \   'cocstatus': 'coc#status'
      \ },
      \ }

" Use auocmd to force lightline update (for coc change).
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

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

" git
Plug 'ruanyl/vim-gh-line'
Plug 'lambdalisue/gina.vim'

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
Plug 'tpope/vim-bundler', { 'for': 'ruby' }

" testing
Plug 'janko/vim-test', { 'on': ['TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit'] }

let test#strategy = "neovim"
nmap <leader>tt :TestNearest<CR>
" run a single test and get full output in terminal
nmap <leader>tT :TestNearest<CR>
nmap <leader>tf :TestFile<CR>
nmap <leader>ta :TestSuite<CR>
nmap <leader>tl :TestLast<CR>
nmap <leader>tv :TestVisit<CR>

" Intellisense
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = ['coc-solargraph', 'coc-tsserver', 'coc-json', 'coc-html', 'coc-css', 'coc-markdownlint', 'coc-spell-checker', 'coc-yaml']

" Coc Config
" For getting set up, this is copy/pasted from README
" TODO: Update/move/remove as it makes sense

"
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD :call CocAction('jumpDefinition', 'vspit')<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>


" =================
" </Programming>
" =================

call plug#end()
