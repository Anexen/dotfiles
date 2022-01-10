let s:neomake_exists = exists('neomake#GetJobs')

function! StatuslineReadonly()
    return &readonly ? '' : ''
endfunction

function! StatuslineFugitive()
    if exists('*fugitive#head')
        let branch = fugitive#head()
        return branch !=# '' ? ' '.branch : ''
    endif
    return ''
endfunction


function! StatuslineNeomakeJobs(prefix, suffix) abort
    if !s:neomake_exists
        return ''
    endif

    let jobs = neomake#GetJobs()

    if empty(jobs)
        return ''
    endif

    let names = map(jobs, 'v:val.name')
    return  a:prefix . join(names, ', ') . a:suffix
endfunction


function! StatuslineFileFormat()
    if &fileformat == 'unix'
        return ''
    endif

    return winwidth(0) > 70 ? &fileformat : ''
endfunction


function! ActiveStatusLine()
    let current_mode = mode()

    if current_mode ==# "i" || current_mode ==# "t"
        highlight link StatusLineActiveMode StatusLineActiveInsertMode
        highlight link StatusLineActiveModeText StatusLineActiveInsertModeText
    elseif current_mode ==# "v" || current_mode ==# 'V' || current_mode ==# "\<C-V>"
        highlight link StatusLineActiveMode StatusLineActiveVisualMode
        highlight link StatusLineActiveModeText StatusLineActiveVisualModeText
    elseif current_mode ==# "R"
        highlight link StatusLineActiveMode StatusLineActiveReplaceMode
        highlight link StatusLineActiveModeText StatusLineActiveReplaceModeText
    else
        highlight link StatusLineActiveMode StatusLineActiveNormalMode
        highlight link StatusLineActiveModeText StatusLineActiveNormalModeText
    endif

    let statusline = ""

    " left:
    let statusline .= "%#StatuslineActiveMode# %{winnr()} "

    let statusline .= "%#StatusLineTextItalic# (%{fnamemodify(getcwd(), ':t')}) %" . (winwidth(0) > 100 ? "" : ".40") . "f%m%r"

    if winwidth(0) > 70 && &fileformat != 'unix'
        let statusline .= "[%{&fileformat}]"
    endif

    let encoding = &fileencoding ? &fileencoding : &encoding
    if winwidth(0) > 70 && encoding != 'utf-8'
        let statusline .= "[%{&fileencoding}]"
    endif

    " right:
    let statusline .= "%#StatusLineActiveModeText# %="

    let jobs = ''
    let jobs .= StatuslineNeomakeJobs('[', ']')
    if exists('gutentags#statusline')
        let jobs .= gutentags#statusline('[', ']')
    endif

    if !empty(jobs)
        let statusline .= " %#StatusLineJobsSection#" . jobs . ""
    endif

    let ext_modes = ''
    let ext_modes .= get(get(g:, "context", {}), "enabled") ? "c" : ""
    let ext_modes .= get(b:, "hexokinase_is_on") ? "C" : ""
    let ext_modes .= get(b:, "hardtime_on") ? "h" : ""
    let ext_modes .= g:neomake_live_mode ? "N" : ""
    let ext_modes .= &paste ? "P" : ""
    let ext_modes .= get(g:, "spelling_enabled") ? "s" : ""
    let ext_modes .= get(b:, "whitespace_enabled") ? "w" : ""

    if !empty(ext_modes)
        let statusline .= " %#StatusLineExtensionSection#{" . ext_modes . "}"
    endif

    let has_running_jobs = s:neomake_exists ? !empty(neomake#GetJobs()) : 0
    let sl_errors = 0
    let sl_warnings = 0
    let sl_info = 0

    if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
        let sl_errors += luaeval("#vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR})")
        let sl_warnings += luaeval("#vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARNING})")
        let sl_info += luaeval("#vim.diagnostic.get(0, {severity = vim.diagnostic.severity.INFO})")
    endif

    if !has_running_jobs && s:neomake_exists
        let linter_errors = neomake#statusline#LoclistCounts()
        let sl_errors += get(linter_errors, 'E', 0)
        let sl_warnings += get(linter_errors, 'W', 0)
        let sl_info += get(linter_errors, 'I', 0)
    endif

    let statusline .= " %#StatusLineError#●" . (has_running_jobs ? '?' : sl_errors)
    let statusline .= " %#StatusLineWarning#●" . (has_running_jobs ? '?' : sl_warnings)
    let statusline .= " %#StatusLineInfo#●" . (has_running_jobs ? '?' : sl_info)

    let statusline .= " %#StatusLineText#%2.p%%"
    let statusline .= " %#StatusLineActiveMode# %3.l:%-2.c %#Normal#"

    return statusline
endfunction


function! InactiveStatusLine()
    let statusline = ""
    " left:
    let statusline .= "%#StatusLineInactiveMode# %{winnr()} "
    let statusline .= "%#StatusLineTextItalic# (%{fnamemodify(getcwd(), ':t')}) %" . (winwidth(0) > 100 ? "" : ".40") . "f%m%r%#StatusLineInactiveModeText# "
    " reght
    let statusline .= "%=%#Normal#"
    return statusline
endfunction

augroup Statusline
  autocmd!
  autocmd WinEnter,BufEnter * setlocal statusline=%!ActiveStatusLine()
  autocmd WinLeave,BufLeave * setlocal statusline=%!InactiveStatusLine()
augroup END

