## Readline bindings ##

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
# bind '"\e[1;5D": backward-word'
# bind '"\e[1;5C": forward-word'

# Perform file completion in a case insensitive fashion
bind "set completion-ignore-case on"
# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"
# Display matches for ambiguous patterns at first tab press
# bind "set show-all-if-ambiguous on"
# Immediately add a trailing slash when autocompleting symlinks to directories
bind "set mark-symlinked-directories on"
# color files by types
bind "set colored-stats on"
# append char to indicate type
bind "set visible-stats on"
# color the common prefix
bind "set colored-completion-prefix on"
# color the common prefix in menu-complete
bind "set menu-complete-display-prefix on"
# disable deep
bind "set bell-style none"

