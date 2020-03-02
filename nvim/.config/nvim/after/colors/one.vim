highlight link Quote String

highlight link NeomakeVirtualtextError NeomakeErrorSign
highlight link NeomakeVirtualtextWarning NeomakeWarningSign
highlight link NeomakeVirtualtextInfo NeomakeInfoSign
highlight link NeomakeVirtualtextMessage NeomakeMessageSign

call one#highlight('NeomakeErrorSign', g:terminal_color_1, '', '')
call one#highlight('NeomakeWarningSign', g:terminal_color_3, '', '')
call one#highlight('NeomakeInfoSign', g:terminal_color_4, '', '')

call one#highlight('NeomakeError', g:terminal_color_1, '', 'underline')
call one#highlight('NeomakeWarning', g:terminal_color_3, '', 'underline')
call one#highlight('NeomakeInfo', g:terminal_color_4, '', 'underline')

call one#highlight('StatusLine', g:one_dark_syntax_bg, g:one_dark_syntax_bg, '')
call one#highlight('StatusLineNC', g:one_dark_syntax_bg, g:one_dark_syntax_bg, '')

call one#highlight('StatusLineActiveNormalMode', g:terminal_color_0, g:terminal_color_2, 'bold')
call one#highlight('StatusLineActiveInsertMode', g:terminal_color_0, g:terminal_color_4, 'bold')
call one#highlight('StatusLineActiveVisualMode', g:terminal_color_0, g:terminal_color_5, 'bold')
call one#highlight('StatusLineActiveReplaceMode', g:terminal_color_1, g:terminal_color_1, 'bold')

call one#highlight('StatusLineActiveNormalModeText', g:terminal_color_2, g:terminal_color_0, '')
call one#highlight('StatusLineActiveInsertModeText', g:terminal_color_4, g:terminal_color_0, '')
call one#highlight('StatusLineActiveVisualModeText', g:terminal_color_5, g:terminal_color_0, '')
call one#highlight('StatusLineActiveReplaceModeText', g:terminal_color_1, g:terminal_color_0, '')

call one#highlight('StatusLineText', g:terminal_color_7, g:terminal_color_0, '')
call one#highlight('StatusLineTextItalic', g:terminal_color_7, g:terminal_color_0, 'italic')

call one#highlight('StatusLineInactiveMode', g:terminal_color_0, g:terminal_color_3, 'bold')
call one#highlight('StatusLineInactiveModeText', g:terminal_color_3, g:terminal_color_0, '')

call one#highlight('StatusLineError', g:terminal_color_1, g:terminal_color_0, '')
call one#highlight('StatusLineWarning', g:terminal_color_3, g:terminal_color_0, '')
call one#highlight('StatusLineInfo', g:terminal_color_4, g:terminal_color_0, '')

highlight link StatusLineJobsSection StatusLineText
call one#highlight('StatusLineExtensionSection', g:terminal_color_5, g:terminal_color_0, 'bold')
