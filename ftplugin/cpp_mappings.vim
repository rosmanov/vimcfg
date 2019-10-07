" Only do this when not done yet for this buffer.
if exists("b:did_cpp_mappings_ftplugin")
    finish
endif
let b:did_cpp_mappings_ftplugin = 1

" Add mappings, unless the user didn't want this.
"if !exists("no_plugin_maps") && !exists("no_mail_maps")
  "nmap <buffer> <unique> gd <plug>(lsp-definition)
"endif
