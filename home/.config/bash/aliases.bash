alias ..='cd ..'         # Go up one directory
alias cd..='cd ..'       # Common misspelling for going up one directory
alias ...='cd ../..'     # Go up two directories
alias ....='cd ../../..' # Go up three directories

alias ls='ls -h --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias lal='ls -lA'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias py='python'
alias ipy='ipython'

alias suod='sudo'
alias sduo='sudo'

alias yank='xclip -sel clip -r'
alias passgen='cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 32 | head -n 1'

alias tree='tree -I __pycache__'

alias vbrc='nvim ~/.config/bash/main.bash'
alias vvrc='nvim ~/.config/nvim/init.lua'
alias src='source ~/.bashrc'
alias cdpr='cd $(git rev-parse --show-toplevel)'

alias bat='bat --theme TwoDark'
alias delta='delta --syntax-theme TwoDark'
alias cg='ast-grep'

alias bmake='make -C ~/projects/aprenita/aprenita-infrastructure'
alias awslocal='aws --endpoint-url=http://localhost:4566 --profile local'
