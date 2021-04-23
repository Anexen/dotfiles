short_dirname () {
    local dir_name=`dirs -0`
    [ ${#dir_name} -gt 8 ] && echo ${dir_name##*/} || echo $dir_name
}

reload_history () {
    history -a
    history -c
    history -r
}

starship_precmd_user_func="reload_history"

eval "$(starship init bash)"

