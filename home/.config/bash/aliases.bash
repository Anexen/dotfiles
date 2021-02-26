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

alias ctclip='xclip -sel clip'
alias passgen='cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 32 | head -n 1'

alias tree='tree -I __pycache__'

alias vim=nvim
alias vbrc='vim ~/.config/bash/main.bash'
alias vvrc='vim ~/.config/nvim/init.vim'
alias src='source ~/.bashrc'

alias bat='bat --theme TwoDark'
alias delta='delta --theme TwoDark'

ch_client_image=yandex/clickhouse-client:20.3.18.10

for (( i = 0; i < ${#SECRET_CH_PROD_IPS[@]}; i++ )); do
    alias "ch_prod_n$(( i + 1))"="docker run --rm -it ${ch_client_image} \
        --host ${SECRET_CH_PROD_IPS[$i]} \
        --user ${SECRET_CH_PROD_USER} \
        --password ${SECRET_CH_PROD_PASSWORD}"
done

for i in {0..3}; do
    for (( j = 0; j < ${#SECRET_CH_STAGING_IPS[@]}; j++ )); do
        alias "ch_staging$(( i + 1))_n$(( j + 1))"="docker run --rm -it ${ch_client_image} \
            --host ${SECRET_CH_STAGING_IPS[${j}]} \
            --port 900$(( i + 1)) \
            --user ${SECRET_CH_STAGING_USER} \
            --password ${SECRET_CH_STAGING_PASSWORD}"
    done
done

