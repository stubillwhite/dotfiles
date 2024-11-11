#!/bin/zsh

RED='\033[0;31m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'
CLEAR_LINE='\r\033[K'

function msg_success() {
    declare msg=$1
    printf "${CLEAR_LINE}${GREEN}✔ ${msg}${NO_COLOR}\n"
}

function msg_error() {
    declare msg=$1
    printf "${CLEAR_LINE}${RED}✘ ${msg}${NO_COLOR}\n"
}

function clone-if-not-present() {
    local repoUrl=$1
    local flags=$2
    local repoPath=$(echo "${repoUrl}" | gsed 's|.*/\(.\+\)\.git|\1|g')

    if [ -d "${repoPath}" ]; then
        msg_success "${repoPath} exists"
    else
        git clone "${flags}" "${repoUrl}"
    fi
}

REPOS=(
    .emacs.d
    cookiecutters
    llm-dnd
    llm-scratchpad
    nvim
    prezto
    shell-utils
    tech-radar
)

pushd .. 

for repo in "${REPOS[@]}"
do
    clone-if-not-present "git@github-personal:stubillwhite/${repo}.git"
done

popd
