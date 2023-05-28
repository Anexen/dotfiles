nnoremap <buffer> <LocalLeader>= :Neoformat rustfmt<CR>

" TODO: neomake makers
nnoremap <buffer> <LocalLeader>cb :!cargo build<CR>
nnoremap <buffer> <LocalLeader>c<S-b> :!cargo build --release<CR>
nnoremap <buffer> <LocalLeader>cr :!cargo run --release<CR>
nnoremap <buffer> <LocalLeader>c<S-r> :!cargo run --release<CR>
nnoremap <buffer> <LocalLeader>ct :!cargo test<CR>
nnoremap <buffer> <LocalLeader>c<S-t> :!cargo test<CR>

setlocal spellfile=~/.config/nvim/spell/rust.utf-8.add
