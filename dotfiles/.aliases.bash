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
alias uuid-gen='cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1'

alias dotdrop='dotdrop --cfg=~/projects/dotfiles/config.yaml'

alias vim=nvim
alias vbrc='vim ~/.bashrc'
alias vvrc='vim ~/.config/nvim/init.vim'
alias src='source ~/.bashrc'

ch_client_image=yandex/clickhouse-client:19.3.5

for (( i = 0; i < ${#SECRET_CH_PROD_IPS[@]}; i++ )); do
    alias "ch_prod_n$(( i + 1))"="docker run --rm -it ${ch_client_image} \
        --host ${SECRET_CH_PROD_IPS[$i]} \
        --user ${SECRET_CH_PROD_USER} \
        --password ${SECRET_CH_PROD_PASSWORD}"
done

for (( i = 0; i < ${#SECRET_CH_STAGING_IPS[@]}; i++ )); do
    alias "ch_staging_n$(( i + 1))"="docker run --rm -it ${ch_client_image} \
        --host ${SECRET_CH_STAGING_IPS[$i]} \
        --user ${SECRET_CH_STAGING_USER} \
        --password ${SECRET_CH_STAGING_PASSWORD}"
done

