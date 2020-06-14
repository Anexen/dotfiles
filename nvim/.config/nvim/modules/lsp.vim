let g:LanguageClient_serverCommands = {
\   'python': ['pyls'],
\   'rust': ['rustup', 'run', 'nightly', 'rls'],
\   'javascript': ['tcp://127.0.0.1:5001'],
\   'c': ['clangd', '--background-index'],
\   'cpp': ['clangd', '--background-index'],
\ }

" Diagnostics are disabled in favor of Neomake
let g:LanguageClient_diagnosticsEnable = 0
let g:LanguageClient_hasSnippetSupport = 1

function! SetLSPShortcuts()
    if !has_key(g:LanguageClient_serverCommands, &filetype)
        return
    endif

    nnoremap <buffer> K :call LanguageClient#textDocument_hover()<CR>
    nnoremap <buffer> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <buffer> g<S-d> :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>

    nnoremap <buffer> <LocalLeader>gt :call LanguageClient#textDocument_typeDefinition()<CR>
    nnoremap <buffer> <LocalLeader>gi :call LanguageClient#textDocument_implementation()<CR>
    nnoremap <buffer> <LocalLeader>gr :call LanguageClient#textDocument_references()<CR>
    nnoremap <buffer> <LocalLeader><S-r> :call LanguageClient#textDocument_rename()<CR>
    nnoremap <buffer> <LocalLeader>s :call LanguageClient#textDocument_signatureHelp()<CR>
endfunction

autocmd! FileType * call SetLSPShortcuts()

