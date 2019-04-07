let g:cpp_after = 1
if exists('g:my_clangd_executable') && executable(g:my_clangd_executable)
  setl omnifunc=lsp#complete | let g:omnifunc_lsp_complete = 1
endif
