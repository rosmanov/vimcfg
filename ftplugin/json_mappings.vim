" Only do this when not done yet for this buffer.
if exists("b:did_json_mappings_ftplugin")
    finish
endif
let b:did_json_mappings_ftplugin = 1

" Add mappings, unless the user didn't want this.
if !exists('no_plugin_maps') && !exists('no_mail_maps')
    if !hasmapto('<Plug>JsonFormat')
        map <buffer> <unique> <F2> <Plug>JsonFormat
    endif
    nnoremap <buffer> <unique> <Plug>JsonFormat <Esc>:%!python -m json.tool<CR>
endif
