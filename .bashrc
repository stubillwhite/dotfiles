# Include common configuration
source $HOME/.common.sh

# No flow control, so C-s is free for C-r/C-s back/forward incremental search
stty -ixon

# Include machine-specific configuration
source_if_exists "$HOME/.bashrc.local.sh"
