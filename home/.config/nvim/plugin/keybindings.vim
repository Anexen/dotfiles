let g:mapleader = "\<Space>"
let g:maplocalleader = ','


function! MoveBuffer(window) abort
    let current_buffer = bufnr('%')
    execute a:window.'wincmd w'
    execute 'b'.current_buffer
endfunction


function! IsQuickfixOpen()
    return len(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist'))
endfunction


" https://github.com/junegunn/fzf.vim/issues/544
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<C-\><C-n>"

onoremap il :<c-u>normal! _vg_<cr>
vnoremap il :<c-u>normal! _vg_<cr>

" (de)indent using tab in normal and visual modes
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

vnoremap <silent> t :Translate<CR>
vnoremap <silent> <S-t> :Translate!<CR>

" |-------------+---+-------------------+-------+-------------------|
" | Camelize    | c | Some Text To Work | gI$c  | someTextToWork    |
" | Privatize   | p | some_var          | gI$p  | _some_var         |
" | Constantize | C | some text to work | gI$C  | SOME_TEXT_TO_WORK |
" | Titleize    | t | some text to work | gI$t  | Some Text To Work |
" | Normalize   | n | SOME_TEXT_TO_WORK | gI$n  | some text to work |
" | FreeBallIt  | f | some text to work | gI$f& | some&text&to&work |
" | Pascalize   | P | some.text.to.work | gIiWP | SomeTextToWork    |
" | Slashify    | / | SOME_TEXT_TO_WORK | gIiw/ | some/text/to/work |
" | Dasherize   | - | some_text_to_work | gIiw- | some-text-to-work |
" | Dotify      | . | someTextToWork    | gIiw. | some.text.to.work |
" | Underscore  | _ | some text to work | gI$_  | some_text_to_work |
" |-------------+---+-------------------+-------+-------------------|
nmap gI <Plug>(Inflect)
vmap gI <Plug>(Inflect)

nmap <ScrollWheelUp> <C-y>
nmap <ScrollWheelDown> <C-e>

function! s:visualSearch(cmdtype)
    let temp = @s
    normal! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
endfunction

xnoremap * :<C-u>call <SID>visualSearch('/')<CR>/<C-r>=@/<CR><CR>
xnoremap # :<C-u>call <SID>visualSearch('?')<CR>?<C-r>=@/<CR><CR>

" last used buffer
nnoremap <Leader><Tab> :e#<CR>
nnoremap <Leader>qq :qa<CR>

nnoremap <Leader>1 :1wincmd w<CR>
nnoremap <Leader>2 :2wincmd w<CR>
nnoremap <Leader>3 :3wincmd w<CR>
nnoremap <Leader>4 :4wincmd w<CR>

nnoremap <expr> K ":vert h ".expand('<cword>')."<CR>"

" +buffers

nnoremap <silent> <Leader>bq :copen<CR>
nnoremap <silent> <Leader>bl :lopen<CR>
nnoremap <silent> <Leader>bb :Buffers<CR>
nnoremap <silent> <Leader>bm :messages<CR>
nnoremap <silent> <Leader>bd :bd<CR>
nnoremap <silent> <Leader>b<S-d> :b#\|bd#<CR>
nnoremap <silent> <Leader>bn :bnext<CR>
nnoremap <silent> <Leader>bp :bprev<CR>
nnoremap <silent> <Leader>bt :TagbarToggle<CR>
nnoremap <silent> <Leader>b<S-n> :enew<CR>

nnoremap <silent> <Leader>b1 :call MoveBuffer(1)<CR>
nnoremap <silent> <Leader>b2 :call MoveBuffer(2)<CR>
nnoremap <silent> <Leader>b3 :call MoveBuffer(3)<CR>
nnoremap <silent> <Leader>b4 :call MoveBuffer(4)<CR>

" +errors
nnoremap <Leader>ee :call NeomakeLiveModeToggle()<CR>
nnoremap <Leader>ed :lclose<CR>
nnoremap <Leader>er :Neomake<Space>
nnoremap <Leader>e<S-r> :Neomake<CR>
nnoremap <Leader>eg :call NeomakeGitDiff()<CR>
nnoremap <Leader>el :lopen<CR>
nnoremap <Leader>en :lnext<CR>
nnoremap <Leader>ep :lprev<CR>
nnoremap <Leader>ec :ll<CR>
" copy (save) loclist to qflist
nnoremap <Leader>es :call setqflist(getloclist(winnr()))<CR>

" +git/version control
nnoremap <Leader>gb :Git blame<CR>
nnoremap <Leader>gc :BCommits<CR>
nnoremap <Leader>gl :Gclog<CR>
nnoremap <Leader>gs :Git<CR>
nnoremap <Leader>gha :Gitsigns stage_hunk<CR>
nnoremap <Leader>ghu :Gitsigns reset_hunk<CR>
nnoremap <Leader>ghn :Gitsigns next_hunk<CR>
nnoremap <Leader>ghp :Gitsigns prev_hunk<CR>
nnoremap <Leader>ghs :Gitsigns stage_buffer<CR>

" +insert
nnoremap <Leader>ik O<Esc>j
nnoremap <Leader>ij o<Esc>k

" +list (QuickFix/LocList)
nnoremap <Leader>lq :copen<CR>
nnoremap <Leader>ll :lopen<CR>
nnoremap <expr> <Leader>ln (IsQuickfixOpen() ? ':cnext' : ':lnext')."\<CR>"
nnoremap <expr> <Leader>lp (IsQuickfixOpen() ? ':cprev' : ':lprev')."\<CR>"
nnoremap <expr> <Leader>lc (IsQuickfixOpen() ? ':cc' : ':ll')."\<CR>"
nnoremap <expr> <Leader>ld (IsQuickfixOpen() ? ':cclose' : ':lclose')."\<CR>"

" +jump
nnoremap <Leader>jd :call ExplorerToggle('%:p:h')<CR>
nnoremap <Leader>jr :call ExplorerToggle('.')<CR>
nnoremap <Leader>jb :b bash<CR>
" jump tag
nnoremap <Leader>jt  <C-]>

" +files
nnoremap <Leader>fs :update<CR>
nnoremap <Leader>fr :History<CR>
nnoremap <Leader>f<S-r> :!rm %<CR>
nnoremap <Leader>ff :call ExplorerToggle('.')<CR>
nnoremap <expr> <Leader>fc ':e '.expand('%:h').'/'
nnoremap <expr> <Leader>fd ':Files '.expand('%:h').'<CR>'
nnoremap <expr> <Leader>fm ':!mv '.expand('%').' '.expand('%:h').'/'

" +files/edit
nnoremap <Leader>fev :e $MYVIMRC <bar> :lcd %:h<CR>
nnoremap <Leader>fer :source $MYVIMRC<CR>
nnoremap <Leader>feb :e ~/.config/bash/main.bash <bar> :lcd %:h<CR>

" +files/yank
" file name under cursor
nnoremap <silent> <Leader>fyc :let @+=expand('<cfile>')<CR>
" file name
nnoremap <silent> <Leader>fyn :let @+=expand('%:t')<CR>
" relative file name
nnoremap <silent> <Leader>fyy :let @+=expand('%:f')<CR>
" absolute file name
nnoremap <silent> <Leader>fy<S-y> :let @+=expand('%:p')<CR>
" relative file name with line number
nnoremap <silent> <Leader>fyl :let @+=expand('%:f').':'.line('.')<CR>
" absolute file name with line number
nnoremap <silent> <Leader>fy<S-l> :let @+=expand('%:p').':'.line('.')<CR>

" +mode
nnoremap <Leader>me :call NeomakeLiveModeToggle()<CR>
nnoremap <Leader>mc :ContextToggle<CR>
nnoremap <Leader>m<S-c> :HexokinaseToggle<CR>
nnoremap <Leader>mh :HardTimeToggle<CR>
nnoremap <expr> <Leader>mn ":setlocal ".(&relativenumber ? "no" : "")."relativenumber<CR>"
nnoremap <expr> <Leader>mr ":setlocal colorcolumn=".(&colorcolumn == '0' ? get(b:, 'textwidth', 0) : '0')."<CR>"
nnoremap <Leader>ms :SpellingToggle<CR>
nnoremap <Leader>mt :TableModeToggle<CR>
nnoremap <expr> <Leader>mp ":setlocal ".(&paste ? "no" : "")."paste<CR>"
nnoremap <Leader>mu :UndotreeToggle<CR>
nnoremap <Leader>mw :call WhitespaceToggle()<CR>

" +project

function! s:get_projects()
    return 'fd --type d --no-ignore --hidden --max-depth=3 ".git$" ~/projects | xargs dirname | sed "s#${HOME}/projects/##g"'
endfunction

function! s:handle_selected_project(directory)
    execute 'cd '.fnameescape('~/projects/' . a:directory)
    Files
    " Fixes issue with NeoVim
    " See https://github.com/junegunn/fzf/issues/426#issuecomment-158115912
    if has('nvim') && !has('nvim-0.5.0')
        call feedkeys('i')
    endif
endfunction

function! SwitchToProject()
    call fzf#run(fzf#wrap({
        \ 'source': s:get_projects(),
        \ 'sink': function('s:handle_selected_project'),
        \ 'layout': g:fzf_layout,
        \ }))
endfunction

command! Projects call SwitchToProject()

nnoremap <Leader>pf :Files<CR>
nnoremap <Leader>po :e notes.md<CR>
nnoremap <Leader>pq :e .queries.sql<CR>
nnoremap <Leader>pp :Projects<CR>
nnoremap <Leader>pr :ProjectRoot<CR>
nnoremap <Leader>pt :botright 12split +terminal \| startinsert<CR>

" +search
nnoremap <Leader>sc :noh<CR>
nmap <Leader>sa <Plug>RgRawSearch--<Space>''<Left>
vmap <Leader>sa :RgSelectedFixedString<CR>
nnoremap <Leader>sb :BLines<CR>
nmap <Leader>sw <Plug>RgRawWordUnderCursor<CR>
nmap <Leader>sl :Rg<Up><CR>
nnoremap <Leader>st :Tags<CR>
nnoremap <expr> <Leader>s<S-t> ":Tags " . expand('<cword>') . "<CR>"
nnoremap <expr> <Leader>sd "<Plug>RgRawSearch-- '" . input("> ") . "' " . expand('%:h') . "<CR>"
nnoremap <Leader>sp :Rg<CR>
nnoremap <Leader>sg :call WebSearch(expand('<cword>'))<CR>

" +tabs
nnoremap <Leader>tn :tabnext<CR>
nnoremap <Leader>tp :tabprev<CR>
nnoremap <Leader>td :tabclose<CR>
nnoremap <Leader>t<S-n> :tabnew<CR>

" +windows
nnoremap <Leader>ww :Windows<CR>
nnoremap <Leader>wd <C-w>c

nnoremap <Leader>ws <C-w>s
nnoremap <Leader>wv <C-w>v

" balance windows
nnoremap <Leader>w= <C-w>=
" resise window
nnoremap <Leader>wh <C-w>5<
nnoremap <Leader>wj :resize +5<CR>
nnoremap <Leader>wl <C-w>5<
nnoremap <Leader>wk :resize -5<CR>


" function! ShowMarks()
"   redir => cout
"   silent marks
"   redir END
"   let marks = split(cout, "\n")
" endfunction
