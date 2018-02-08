" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={{{,}}} foldlevel=0 foldmethod=marker spell:
"
" Author: Ruslan Osmanov <rrosmanov at gmail dot com>

" {{{ vimrc.before
if filereadable(expand("~/.vim/conf.d/vimrc.before"))
  source ~/.vim/conf.d/vimrc.before
endif
" }}}

set nocompatible " Must be the first line
set shell=/bin/bash

" Initialize vim-plug
call plug#begin('~/.vim/plugged')

if !exists('g:my_bundles_file')
  let g:my_bundles_file = "~/.vim/conf.d/vimrc.bundles"
endif
execute 'source' fnameescape(g:my_bundles_file)

" General {{{

set background=dark         " Assume a dark background
filetype plugin indent on   " Automatically detect file types.
syntax on                   " Syntax highlighting
set mouse=a                 " Automatically enable mouse usage
set mousehide               " Hide the mouse cursor while typing
scriptencoding utf-8
set clipboard=unnamedplus
set shortmess+=filmnrxoOtT  " Abbrev. of messages (avoids 'hit enter')
" Better Unix / Windows compatibility
set viewoptions=folds,options,cursor,unix,slash
set history=50
set hidden " Allow buffer switching without saving
set modeline
set modelines=5
set exrc " Set project-specific .vimrc
" Disable autocmd and shell commands in project-specific configuration files
set secure

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
augroup GitCommitFileType
  au!
  au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
  au FileType gitcommit setlocal spell
augroup end

" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
" Restore cursor to file position in previous editing session
" To disable this, add the following to your vimrc.before file:
"   let g:my_no_restore_cursor = 1
if !exists('g:my_no_restore_cursor')
  function! RestoreCursor()
    if line("'\"") <= line("$")
      normal! g`"
      return 1
    endif
  endfunction

  augroup restoreCursor
    autocmd!
    autocmd BufWinEnter * call RestoreCursor()
  augroup END
endif

" {{{ Directories
set backup
if has('persistent_undo')
  set undofile         " So is persistent undo ...
  set undolevels=1000  " Maximum number of changes that can be undone
  set undoreload=10000 " Maximum number lines to save for undo on a buffer reload
endif
" }}}
" }}}

" Vim UI {{{

" We use csapprox plugin so we can use 256-color scheme in CLI, too
if &term != 'linux'
  colorscheme darkspectrum
else
  colorscheme desert
endif

" Fix highlight
au BufEnter <buffer> hi ErrorMsg ctermfg=203 ctermbg=234 guifg=#E5786D guibg=#242424
au BufEnter <buffer> hi Error term=reverse ctermfg=15 ctermbg=9 guifg=White guibg=DarkRed
highlight clear SignColumn " SignColumn should match background
highlight clear LineNr     " Current line number row will have same background color in relative mode

set tabpagemax=15 " Only show 15 tabs
set showmode      " Display the current mode

if has('cmdline_info')
  set noruler
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
  set showcmd " Show partial commands in status line and
  " Selected characters/lines in visual mode
endif

if has('statusline')
  set laststatus=2

  " Broken down into easily includeable segments
  set statusline=%<%f\                     " Filename
  set statusline+=%w%h%m%r                 " Options
  set statusline+=%{fugitive#statusline()} " Git Hotness
  set statusline+=\ [%{&ff}/%Y]            " Filetype
  set statusline+=\ [%{getcwd()}]          " Current dir
  set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set nu                          " Line numbers on
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set foldenable                  " Auto fold code
set list listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
" }}}

" {{{ Formatting
set nowrap            " Do not wrap long lines
set autoindent        " Use autoindent by default
set shiftwidth=2
set expandtab
set tabstop=2         " An indentation every four columns
set softtabstop=2     " Let backspace delete indent
set nojoinspaces      " Prevents inserting two spaces after punctuation on a join (J)
set splitright        " Puts new vsplit windows to the right of the current
set splitbelow        " Puts new split windows to the bottom of the current
set pastetoggle=<F12> " pastetoggle (sane indentation on pastes)
augroup FormatSource
  au!
  au FileType c,cpp,java,go,php,javascript,python,twig,xml,yml autocmd BufWritePre <buffer> call PostFormatSource()
augroup end
augroup CFileType
  au!
  au FileType,BufRead c,cpp,java,go setl cindent cinoptions=N-sp0t0s
augroup end
augroup PhpFiletype
  au!
  au BufNewFile,BufRead *.php,*.cphp,*.phpt call s:FTphp()
augroup end
augroup JavaFiletype
  au!
  au FileType java set ts=4 sts=4 sw=4
augroup end
augroup ChangelogFiletype
  au!
  au Filetype changelog let g:changelog_username="Ruslan Osmanov <rrosmanov@gmail.com>"
augroup end
augroup XmlFiletype
  au!
  " Format XML with F2
  au Filetype xml map <F2> <Esc>:1,$!xmllint --format -<CR>
augroup end
augroup SmartyFiletype
  au!
  au FileType,BufRead smarty setl ft=smarty.html
augroup end
" }}}

" {{{ Key mappings 
if !exists('g:my_maps_file')
  let g:my_maps_file = '~/.vim/conf.d/vimrc.maps'
endif
execute 'source' fnameescape(g:my_maps_file)
" }}}

" Plugins {{{

" {{{ Matchit
let b:match_ignorecase = 1
" }}}

"{{{ Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#omni#input_patterns = {}
let g:deoplete#omni#input_patterns.ruby = ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::']
let g:deoplete#omni#input_patterns.java = '[^. *\t]\.\w*'

" Enable deoplete when InsertEnter.
let g:deoplete#enable_at_startup = 0
augroup Deoplete
  autocmd!
  autocmd InsertEnter * call deoplete#enable()
augroup END

set completeopt+=noinsert

" TAB completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#mappings#manual_complete()
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction "}}}

" Workaround for vim-multiple-cursors plugin
function g:Multiple_cursors_before()
  let g:deoplete#disable_auto_complete = 1
endfunction
function g:Multiple_cursors_after()
  let g:deoplete#disable_auto_complete = 0
endfunction
"}}}

"{{{ vim-notes
let g:notes_directories = ["~/.vim-notes"]
""}}}

"{{{ neosnippet
" Remap the default combination <C-k> which is used to enter digraphs
inoremap <C-y> <C-k>

imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)

"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
"}}}

" {{{ syntaxcomplete
if has("autocmd") && exists("+omnifunc")
  augroup OmniComplete
    autocmd!
  autocmd Filetype *
        \if &omnifunc == "" |
        \setlocal omnifunc=syntaxcomplete#Complete |
        \endif
  augroup END
endif

hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

" Some convenient mappings
inoremap <expr> <Esc>  pumvisible() ? "\<C-e>"                  : "\<Esc>"
inoremap <expr> <CR>   pumvisible() ? "\<C-y>"                  : "\<CR>"
inoremap <expr> <Down> pumvisible() ? "\<C-n>"                  : "\<Down>"
inoremap <expr> <Up>   pumvisible() ? "\<C-p>"                  : "\<Up>"
inoremap <expr> <C-d>  pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
inoremap <expr> <C-u>  pumvisible() ? "\<PageUp>\<C-p>\<C-n>"   : "\<C-u>"

" Automatically open and close the popup menu / preview window
augroup OmniCompleteCursor
  au!
  " Automatically open and close the popup menu / preview window
  au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
  set completeopt+=menu,preview
augroup end
" }}}

" {{{ Ctags
set tags=./tags;/,~/.vimtags

" Make tags placed in .git/tags file available in all levels of a repository
let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
if gitroot != ''
  let &tags = &tags . ',' . gitroot . '/.git/tags'
endif
" Make tags placed in .git/tags file available in all levels of a repository
let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
if gitroot != ''
    let &tags = &tags . ',' . gitroot . '/tags'
endif
" }}}

" {{{ NERDTree
map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
map <leader>e :NERDTreeFind<CR>
nmap <leader>nt :NERDTreeFind<CR>

let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0
" }}}

" {{{ JSON
" Formatting
nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
" }}}

" {{{ PyMode
let g:pymode_lint_checker = "pyflakes"
let g:pymode_utils_whitespaces = 0
let g:pymode_options = 0
" }}}

" {{{ TagBar
nnoremap <silent> <localleader>tt :TagbarToggle<CR>

" If using go please install the gotags program using the following
" go install github.com/jstemmer/gotags
" And make sure gotags is in your path
let g:tagbar_type_go = {
      \ 'ctagstype' : 'go',
      \ 'kinds'     : [  'p:package', 'i:imports:1', 'c:constants', 'v:variables',
      \ 't:types',  'n:interfaces', 'w:fields', 'e:embedded', 'm:methods',
      \ 'r:constructor', 'f:functions' ],
      \ 'sro' : '.',
      \ 'kind2scope' : { 't' : 'ctype', 'n' : 'ntype' },
      \ 'scope2kind' : { 'ctype' : 't', 'ntype' : 'n' },
      \ 'ctagsbin'  : 'gotags',
      \ 'ctagsargs' : '-sort -silent'
      \ }
"}}}

" {{{ PythonMode
if !has('python')
  let g:pymode = 1
endif
" }}}

" {{{ Fugitive
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gr :Gread<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>ge :Gedit<CR>
nnoremap <silent> <leader>gg :SignifyToggle<CR>
"}}}

" {{{ indent_guides

" For some colorschemes, autocolor will not work (eg: 'desert', 'ir_black')
augroup IndentGuides
  autocmd!
  let g:indent_guides_auto_colors = 0
  let g:indent_guides_start_level = 2
  let g:indent_guides_guide_size = 1
  let g:indent_guides_enable_on_vim_startup = 1
  autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#212121 ctermbg=3
  autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#404040 ctermbg=4
augroup END
" }}}

" {{{ vim-airline
let g:airline_theme = 'wombat' " 'solarized' 'powerlineish'
if !exists('g:airline_powerline_fonts')
  " Use the default set of separators with a few customizations
  let g:airline_left_sep='›'  " Slightly fancier than '>'
  let g:airline_right_sep='‹' " Slightly fancier than '<'
endif
" ALE extension info in airline
if exists('g:loaded_ale')
  let g:airline#extensions#ale#enabled = 1
endif
" }}}

if count(g:my_bundle_groups, 'syntax')
  if exists('g:loaded_syntastic_plugin')
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*

    let g:syntastic_always_populate_loc_list = 0
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 0
    let g:syntastic_check_on_wq = 0

    " Fix Syntastic colors
    au BufEnter <buffer> hi SyntasticErrorSign term=standout ctermfg=203 ctermbg=234 guifg=#E5786D guibg=#242424
  endif
endif

if count(g:my_bundle_groups, 'misc')
  if exists('g:my_author')
    let g:DoxygenToolkit_authorName = g:my_author
  endif
endif
" }}}


" GUI Settings {{{

" Gvim
if has('gui_running')
  set guioptions-=T           " Remove the toolbar
  set lines=40                " 40 lines of text instead of 24
  set guifont=Monospace\ 11,Andale\ Mono\ Regular\ 11,Menlo\ Regular\ 11,Consolas\ Regular\ 11,Courier\ New\ Regular\ 11
else
  if &term == 'xterm' || &term == 'screen'
    set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
  elseif &term == 'linux'
    set t_Co=8
  endif
endif
" }}}

" {{{ Functions

" Initialize NERDTree as needed {{{
function! NERDTreeInitAsNeeded()
  redir => bufoutput
  buffers!
  redir END
  let idx = stridx(bufoutput, "NERD_tree")
  if idx > -1
    NERDTreeMirror
    NERDTreeFind
    wincmd l
  endif
endfunction
" }}}

" Strip whitespace {{{
function! StripTrailingWhitespace()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the business:
  %s/\s\+$//e
  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
" }}}

"{{{ PostFormatSource()
function! PostFormatSource()
  if !exists('g:my_keep_trailing_whitespace')
    call StripTrailingWhitespace()
  endif
endfunction
"}}}

" Shell command {{{
function! s:RunShellCommand(cmdline)
  botright new

  setlocal buftype=nofile
  setlocal bufhidden=delete
  setlocal nobuflisted
  setlocal noswapfile
  setlocal nowrap
  setlocal filetype=shell
  setlocal syntax=shell

  call setline(1, a:cmdline)
  call setline(2, substitute(a:cmdline, '.', '=', 'g'))
  execute 'silent $read !' . escape(a:cmdline, '%#')
  setlocal nomodifiable
  1
endfunction

command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
" e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
" }}}

" {{{ PHP files
func! s:FTphp()
  setl ft=php
  " PSR
  setl ts=4 sts=4 sw=4

  let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
  let g:deoplete#ignore_sources.php = ['omni']

  let g:PHP_vintage_case_default_indent = 1

  if exists('g:loaded_ale')
    let g:ale_php_phpcs_executable = expand('~/.vim/tools/phpcs.sh')
    let g:ale_php_phpstan_executable = expand('~/.vim/tools/phpstan.sh')
    let g:ale_php_phpcs_standard = 'PSR2'
  elseif exists('g:loaded_syntastic_plugin')
    let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd', 'phpstan']
    let g:syntastic_php_phpcs_args = '--standard=PSR2 -n'
  endif

  if count(g:my_bundle_groups, 'php')
    inoremap <Leader>u <Esc>:call IPhpInsertUse()<CR>
    noremap <Leader>u :call PhpInsertUse()<CR>
  endif

  let delimitMate_matchpairs = "(:),[:],{:}"
  let b:delimitMate_matchpairs = delimitMate_matchpairs

  " Fix Vdebug colors
  hi default DbgCurrentLine guibg=#000000 guifg=#8ae234 ctermfg=81 term=bold
  hi default DbgCurrentSign guibg=#000000 guifg=#8ae234 ctermfg=81 term=bold
  hi default DbgBreakptLine guibg=#202020 guifg=#8ae234 ctermfg=81 term=bold
  hi default DbgBreakptSign guibg=#202020 guifg=#8ae234 ctermfg=81 term=bold
endfunc

" Inserts "use" statement for namespace of the class under cursor
" using php-namespace plugin
func! IPhpInsertUse()
  call PhpInsertUse()
  call feedkeys('a',  'n')
endfunc
"}}}

func! s:FThaskell()
  set tabstop=8                   "A tab is 8 spaces
  set expandtab                   "Always uses spaces instead of tabs
  set softtabstop=4               "Insert 4 spaces when tab is pressed
  set shiftwidth=4                "An indent is 4 spaces
  set shiftround                  "Round indent to nearest shiftwidth multiple
endfunc

" }}}

" vimrc.after {{{
" This is a place to override settings. For instance, you can set different
" settings depending on current path:
"
"    function! SetupProjectEnvironment()
"    let l:path = expand('%:p')
"    if l:path =~ '/www/s3/'
"      if &filetype == 'yaml'
"        setlocal et ts=2 sw=2 sts=2
"      else
"        setlocal noet ts=2 sts=2 sw=2
"      endif
"    endif
"    endfunction
"    autocmd! BufReadPost,BufNewFile * call SetupProjectEnvironment()
"
"    See http://vim.wikia.com/wiki/Project_specific_settings

if filereadable(expand("~/.vim/conf.d/vimrc.after"))
  source ~/.vim/conf.d/vimrc.after
endif
" }}}
