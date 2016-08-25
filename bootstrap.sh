#!/bin/zsh

setopt EXTENDED_GLOB

FILES=(
    ".bashrc"
    ".zshrc"
    ".commonrc"
    ".gitconfig"
    ".lein"
)

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

for FILE in "${FILES[@]}"
do
    HOME_FILE="$HOME/`basename $FILE`"
    echo Creating link $HOME_FILE
    rm -f $HOME_FILE 2> /dev/null || true
    ln -s `realpath $FILE` $HOME_FILE
done
