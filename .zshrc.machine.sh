# BOS development tool functions
source_if_exists "/Users/white1/Dev/bos/bos-dev-tools/aws.sh"
alias assume-role=source\ ~/Dev/my-stuff/utils/assume-role.sh

# AWS tools
source_if_exists "/usr/local/bin/aws_zsh_completer.sh"

# Machine specific variables
export HOMEBREW_GITHUB_API_TOKEN="149ed15bbace62be26660c640b46fd2c0e20abda"

# Clean up after annoying Emacs 25.1 crash on OSX
alias clean-emacs=rm\ -rf\ ~/.emacs-backup\ ~/.emacs-undo-tree
