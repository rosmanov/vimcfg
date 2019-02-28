" Only do this when not done yet for this buffer.
if exists("b:did_php_mappings_ftplugin")
    finish
endif
let b:did_php_mappings_ftplugin = 1

" Add mappings, unless the user didn't want this.
if !exists("no_plugin_maps") && !exists("no_mail_maps")
  if !hasmapto('<Plug>PhpactorDefinition')
    map <buffer> <unique> <Leader>d <Plug>PhpactorDefinition
  endif
  nnoremap <buffer> <unique> <Plug>PhpactorDefinition :call phpactor#GotoDefinition()<CR>

  if !hasmapto('<Plug>PhpactorTransform')
    map <buffer> <unique> <Leader>tr <Plug>PhpactorTransform
  endif
  nnoremap <buffer> <unique> <Plug>PhpactorTransform :call phpactor#Transform()<CR>

  if !hasmapto('<Plug>PhpactorNamespace')
    map <buffer> <unique> <Leader>u <Plug>PhpactorNamespace
  endif
  inoremap <buffer> <unique> <Plug>PhpactorNamespace <Esc>:call phpactor#UseAdd()<CR>
  nnoremap <buffer> <unique> <Plug>PhpactorNamespace :call phpactor#UseAdd()<CR>

  if !hasmapto('<Plug>PhpactorContextmenu')
    map <buffer> <unique> <Leader>m <Plug>PhpactorContextmenu
  endif
  inoremap <buffer> <unique> <Plug>PhpactorContextmenu <Esc>:call phpactor#ContextMenu()<CR>
  nnoremap <buffer> <unique> <Plug>PhpactorContextmenu :call phpactor#ContextMenu()<CR>
endif
