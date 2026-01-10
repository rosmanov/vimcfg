set lines=40 columns=120
"winpos 0 0
"set guioptions=aegiLt
"set guifont=Monospace\ 16,Andale\ Mono\ Regular\ 16,Menlo\ Regular\ 16,Consolas\ Regular\ 16,Courier\ New\ Regular\ 16
"set guifont=Monaco:h16
:GuiFont Monaco:h14.5

" Enable Mouse
set mouse=a

" Set Editor Font
"if exists(':GuiFont')
    "" Use GuiFont! to ignore font errors
    "GuiFont {font_name}:h{size}
"endif

" Disable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 0
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif

" Enable GUI ScrollBar
if exists(':GuiScrollBar')
    GuiScrollBar 1
endif

" Right Click Context Menu (Copy-Cut-Paste)
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv

let g:coc_node_path = '/usr/local/bin/node'
