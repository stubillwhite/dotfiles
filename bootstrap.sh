#!/bin/zsh

setopt EXTENDED_GLOB

FILES=(
    ".bashrc"
    ".bashrc.machine.sh"
    ".zshrc"
    ".zshrc.machine.sh"
    ".common.sh"
    ".gitconfig"
    ".ssh"
    "leiningen/.lein"
    "boot/.boot"
    "tmux/.tmux.conf"
)

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

for FILE in "${FILES[@]}"
do
    HOME_FILE="$HOME/`basename $FILE`"
    if [[ -e $FILE ]]; then
        echo Creating link $HOME_FILE
        rm -f $HOME_FILE 2> /dev/null || true
        ln -s `realpath $FILE` $HOME_FILE
    fi
done
