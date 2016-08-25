# Include common configuration
source $HOME/.commonrc

# Include machine-specific configuration
source_if_exists "$HOME/.machinerc"

# No flow control, so C-s is free for C-r/C-s back/forward incremental search
stty -ixon
