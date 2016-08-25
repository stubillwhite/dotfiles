# Include common configuration
source ~/.commonrc

# Include machine-specific configuration
source_if_exists "$HOME/.machinerc"

# Include Prezto, but remove unhelpful configuration
source_if_exists "$HOME/.zprezto/init.zsh"
unalias cp
unalias rm
unalias mv
setopt clobber
