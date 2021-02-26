let g:LanguageClient_serverCommands = {
\   'python': ['pyls'],
\   'terraform': ['terraform-ls', 'serve'],
\   'rust': ['rustup', 'run', 'nightly', 'rls'],
\   'javascript': ['tcp://127.0.0.1:5001'],
\   'c': ['clangd', '--background-index'],
\   'cpp': ['clangd', '--background-index'],
\ }

" let g:LanguageClient_diagnosticsEnable = 1

" Diagnostics are disabled in favor of Neomake
let g:LanguageClient_diagnosticsEnable = 0
" let g:LanguageClient_hasSnippetSupport = 1

" let g:LanguageClient_loggingFile =  expand('~/.local/share/nvim/LanguageClient.log')
" let g:LanguageClient_serverStderr = expand('~/.local/share/nvim/LanguageServer.log')

function! SetLSPShortcuts()
    if !has_key(g:LanguageClient_serverCommands, &filetype)
        return
    endif

    nnoremap <buffer> <S-k> :call LanguageClient#textDocument_hover()<CR>
    nnoremap <buffer> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <buffer> g<S-d> :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>

    nnoremap <buffer> <LocalLeader>gt :call LanguageClient#textDocument_typeDefinition()<CR>
    nnoremap <buffer> <LocalLeader>gi :call LanguageClient#textDocument_implementation()<CR>
    nnoremap <buffer> <LocalLeader>gr :call LanguageClient#textDocument_references()<CR>
    nnoremap <buffer> <LocalLeader><S-r> :call LanguageClient#textDocument_rename()<CR>
    nnoremap <buffer> <LocalLeader>s :call LanguageClient#textDocument_signatureHelp()<CR>
    nnoremap <buffer> <LocalLeader>ca :call LanguageClient#textDocument_codeAction()<CR>
    nnoremap <buffer> <LocalLeader>cl :call LanguageClient#textDocument_codeLens()<CR>
    nnoremap <buffer> <LocalLeader>cf :call LanguageClient#textDocument_formatting_sync()<CR>
endfunction

autocmd! FileType * call SetLSPShortcuts()

