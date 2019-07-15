if filereadable(expand("~/.vim/conf.d/vimrc.before"))
  source ~/.vim/conf.d/vimrc.before
endif

set nocompatible " Must be the first line
set shell=/bin/bash

" Initialize vim-plug
call plug#begin('~/.vim/plugged')

if !exists('g:my_bundles_file')
  let g:my_bundles_file = "~/.vim/conf.d/vimrc.bundles"
endif
execute 'source' fnameescape(g:my_bundles_file)

" {{{ General
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
  set undofile         " Enable 'undo' persistence
  set undolevels=1000  " Maximum number of changes that can be undone
  set undoreload=10000 " Maximum number lines to save for undo on a buffer reload
endif
" }}}
" General }}}

" Vim UI {{{

" csapprox plugin enables 256-color scheme in command line interface
if &term != 'linux'
  colorscheme darkspectrum
else
  colorscheme desert
endif

if !has('gui_running')
  if &term == 'xterm' || &term == 'screen'
    " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
    set t_Co=256
  elseif &term == 'linux'
    set t_Co=8
  endif
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
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
  " Show partial commands in status line and
  " selected characters/lines in visual mode
  set showcmd
endif

if has('statusline')
  set laststatus=2 " Always show status line

  set statusline=%<%f\                     " Filename
  set statusline+=%w%h%m%r                 " Options
  set statusline+=%{fugitive#statusline()} " Git Hotness
  set statusline+=\ [%{&ff}/%Y]            " Filetype
  set statusline+=\ [%{getcwd()}]          " Current dir
  set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

set backspace=indent,eol,start
set linespace=0
set nonumber                    " Line numbers off
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
set autoindent
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set nojoinspaces      " Prevents inserting two spaces after punctuation on a join (J)
set splitright        " Puts new vsplit windows to the right of the current
set splitbelow        " Puts new split windows to the bottom of the current
set pastetoggle=<F12> " Key to enable sane indentation on pastes
augroup FormatSource
  au!
  au FileType c,cpp,java,go,php,javascript,python,twig,xml,yml autocmd BufWritePre <buffer> call PostFormatSource()
augroup end
augroup CFileType
  au!
  au FileType,BufRead c,cpp,objc,objcpp,java,go setl cindent cinoptions=N-sp0t0s
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

" YCM
let g:ycm_key_detailed_diagnostics = 0

" Matchit
let b:match_ignorecase = 1

" vim-notes
let g:notes_directories = ["~/.vim-notes"]

"{{{ neosnippet
" Remap the default combination <C-k> which is used to enter digraphs
inoremap <C-d> <C-k>

imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
"}}}

" {{{ CTags and CScope
set tags=./tags;/,~/.vimtags
" Disable "Added cscope database" message on startup
set nocscopeverbose

" Make tags from .git/tags file available in all levels of a repository
let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
if gitroot != ''
  let &tags = &tags . ',' . gitroot . '/.git/tags'
endif
" }}}

"{{{ vim-lsp
" Group for file types using clangd-based Language Server Protocol implementations.
if !exists('g:my_clangd_executable')
  let g:my_clangd_executable = 'clangd'
endif
let g:lsp_async_completion = 1
let g:asyncomplete_popup_delay = 100
let g:lsp_diagnostics_enabled = 0
augroup LspClangdType
  au!
  au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_nifo->[g:my_clangd_executable, '-pch-storage=memory']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
augroup end
"}}}

" {{{ NERDTree
let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0
" }}}

" {{{ PyMode
let g:pymode_lint_checker = "pyflakes"
let g:pymode_utils_whitespaces = 0
let g:pymode_options = 0
if !has('python')
  let g:pymode = 1
endif
" }}}

" {{{ TagBar
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

" {{{ indent_guides

" For some colorschemes, autocolor will not work (e.g: 'desert', 'ir_black')
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
let g:airline#extensions#ale#enabled = 1
" }}}

"{{{ NCM2 (completion manager)
augroup NCM2
  au!
  autocmd BufEnter * call ncm2#enable_for_buffer()
  " enable auto complete for `<backspace>`, `<c-w>` keys.
  " known issue https://github.com/ncm2/ncm2/issues/7
  au TextChangedI * call ncm2#auto_trigger()
  " We shouldn't use 'longest' in completeopt. We also should set 'noinsert'
  set completeopt=noinsert,menuone,noselect
  " Suppress the annoying 'match x of y', 'The only match' and 'Pattern not
  " found' messages
  set shortmess+=c
  let g:ncm2#complete_delay = 60
  let g:ncm2#popup_delay = 60
  let g:ncm2#popup_limit = 10
augroup end
"}}}

" Plugins }}}

"{{{ Plugin fixes
" 'notes' plugin sets completeopt+=longest globally, which badly affects to
" the ncm2 completion badly.
au FileType,BufRead notes set completeopt-=longest
"}}}

" {{{ Functions

function! StripTrailingWhitespace() " {{{
  " Save last search, and cursor position.
  let _s = @/
  let l = line(".")
  let c = col(".")

  %s/\s\+$//e

  let @/=_s
  call cursor(l, c)
endfunction
" }}}

function! PostFormatSource() "{{{
  if !exists('g:my_keep_trailing_whitespace')
    call StripTrailingWhitespace()
  endif
endfunction
"}}}

function! s:RunShellCommand(cmdline) " {{{
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

function! s:FTphp() " {{{
  setl ft=php
  " PSR-2
  setl ts=4 sts=4 sw=4

  "setl completefunc=phpactor#Complete
  setlocal omnifunc=phpactor#Complete
  let g:phpactorOmniError = v:false

  let g:PHP_vintage_case_default_indent = 1

  if !exists('g:ycm_filetype_blacklist')
    let g:ycm_filetype_blacklist = {'php': 1};
  else
    g:ycm_filetype_blacklist['php'] = 1;
  endif

  if exists('g:loaded_ale')
    let g:ale_php_phpcs_executable = expand('~/.vim/tools/phpcs.sh')
    let g:ale_php_phpstan_executable = expand('~/.vim/tools/phpstan.sh')
    let g:ale_php_phpcs_standard = 'PSR2'
  endif

  let delimitMate_matchpairs = "(:),[:],{:}"
  let b:delimitMate_matchpairs = delimitMate_matchpairs
endfunction
" }}}

func! s:FThaskell() "{{{
  set tabstop=8                   "A tab is 8 spaces
  set expandtab                   "Always uses spaces instead of tabs
  set softtabstop=4               "Insert 4 spaces when tab is pressed
  set shiftwidth=4                "An indent is 4 spaces
  set shiftround                  "Round indent to nearest shiftwidth multiple
endfunc
"}}}

" Functions }}}

if filereadable(expand("~/.vim/conf.d/vimrc.after"))
  source ~/.vim/conf.d/vimrc.after
endif
" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={{{,}}} foldlevel=0 foldmethod=marker spell:
