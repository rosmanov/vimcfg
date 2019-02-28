" Only do this when not done yet for this buffer.
if exists("b:did_xml_mappings_ftplugin")
    finish
endif
let b:did_xml_mappings_ftplugin = 1

if !exists("no_plugin_maps") && !exists("no_mail_maps")
  if !hasmapto('<Plug>XmlFormat')
    map <buffer> <unique> <F2> <Plug>XmlFormat
  endif
  nnoremap <buffer> <unique> <Plug>XmlFormat <Esc>:1,$!xmllint --format -<CR>
endif
