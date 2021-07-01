function! Highlight(group, fg, bg, attr, ...)
    let l:attrsp = get(a:, 1, "")
    " fg, bg, attr, attrsp
    if !empty(a:fg)
        exec "hi " . a:group . " guifg=" .  a:fg
        " exec "hi " . a:group . " ctermfg=" . a:fg[1]
    endif
    if !empty(a:bg)
        exec "hi " . a:group . " guibg=" .  a:bg
        " exec "hi " . a:group . " ctermbg=" . a:bg[1]
    endif
    if a:attr != ""
        exec "hi " . a:group . " gui=" .   a:attr
        exec "hi " . a:group . " cterm=" . a:attr
    endif
    if !empty(l:attrsp)
        exec "hi " . a:group . " guisp=" . l:attrsp[0]
    endif
endfunction


highlight Normal guibg=none ctermbg=none
" highlight EndOfBuffer guibg=none ctermbg=none
highlight! link EndOfBuffer Normal

highlight SignColumn guibg=none ctermbg=none

highlight SpellBad guifg=none gui=underline

highlight StatusLine guibg=none ctermbg=none
highlight StatusLineNC guibg=none ctermbg=none


" #222222 g:one_dark_syntax_bg
" g:terminal_color_1  #de5d68
" g:terminal_color_2  #8fb573
" g:terminal_color_3  #dbb671
" g:terminal_color_4  #57a5e5

highlight link NeomakeVirtualtextError NeomakeErrorSign
highlight link NeomakeVirtualtextWarning NeomakeWarningSign
highlight link NeomakeVirtualtextInfo NeomakeInfoSign
highlight link NeomakeVirtualtextMessage NeomakeMessageSign

call Highlight('NeomakeError', g:terminal_color_1, '', 'underline')
call Highlight('NeomakeWarning', g:terminal_color_3, '', 'underline')
call Highlight('NeomakeInfo', g:terminal_color_4, '', 'underline')

call Highlight('StatusLine', "#222222", '#222222', '')
call Highlight('StatusLineNC', "#222222", '#222222', '')

call Highlight('StatusLineActiveNormalMode', g:terminal_color_0, g:terminal_color_2, 'bold')
call Highlight('StatusLineActiveInsertMode', g:terminal_color_0, g:terminal_color_4, 'bold')
call Highlight('StatusLineActiveVisualMode', g:terminal_color_0, g:terminal_color_5, 'bold')
call Highlight('StatusLineActiveReplaceMode', g:terminal_color_0, g:terminal_color_1, 'bold')

call Highlight('StatusLineActiveNormalModeText', g:terminal_color_2, g:terminal_color_0, '')
call Highlight('StatusLineActiveInsertModeText', g:terminal_color_4, g:terminal_color_0, '')
call Highlight('StatusLineActiveVisualModeText', g:terminal_color_5, g:terminal_color_0, '')
call Highlight('StatusLineActiveReplaceModeText', g:terminal_color_1, g:terminal_color_0, '')

call Highlight('StatusLineText', g:terminal_color_7, g:terminal_color_0, '')
call Highlight('StatusLineTextItalic', g:terminal_color_7, g:terminal_color_0, 'italic')

call Highlight('StatusLineInactiveMode', g:terminal_color_0, g:terminal_color_3, 'bold')
call Highlight('StatusLineInactiveModeText', g:terminal_color_3, g:terminal_color_0, '')

call Highlight('StatusLineError', g:terminal_color_1, g:terminal_color_0, '')
call Highlight('StatusLineWarning', g:terminal_color_3, g:terminal_color_0, '')
call Highlight('StatusLineInfo', g:terminal_color_4, g:terminal_color_0, '')
