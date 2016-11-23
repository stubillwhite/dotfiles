# Include common configuration
source $HOME/.common.sh

# Include Prezto, but remove unhelpful configuration
source_if_exists "$HOME/.zprezto/init.zsh"
unalias cp                      # Standard behaviour
unalias rm                      # Standard behaviour
unalias mv                      # Standard behaviour
setopt clobber                  # Happily clobber files 
setopt interactivecomments      # Allow comments in interactive shells
unsetopt AUTO_CD                # Don't change directory autmoatically

# Helper aliases
alias tarf=tar\ -zcvf 
alias untarf=tar\ -zxvf 
alias assume-role=source\ ~/Dev/my-stuff/utils/assume-role.sh
alias eject=diskutil\ eject
alias env=env\ \|\ sort

# Include machine-specific configuration
source_if_exists "$HOME/.zshrc.machine.sh"
