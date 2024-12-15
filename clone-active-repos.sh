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
<<<<<<< HEAD
        echo "Cloining ${repoPath}"
=======
>>>>>>> a7ca844 (OSX Sequoia migration)
        git clone "${flags}" "${repoUrl}"
    fi
}

<<<<<<< HEAD
SHALLOW_REPOS=(
    .emacs.d
    advent-of-code-2023
    cookiecutters
    jira-reporter-python
    llm-dnd
    llm-scratchpad
    nvim
=======
REPOS=(
    .emacs.d
    cookiecutters
    llm-dnd
    llm-scratchpad
    nvim
    prezto
>>>>>>> a7ca844 (OSX Sequoia migration)
    shell-utils
    tech-radar
)

<<<<<<< HEAD
RECURSIVE_REPOS=(
    prezto
)

pushd .. 

for repo in "${SHALLOW_REPOS[@]}"
do
    clone-if-not-present "git@github-personal:stubillwhite/${repo}.git" "-q"
done

for repo in "${RECURSIVE_REPOS[@]}"
do
    clone-if-not-present "git@github-personal:stubillwhite/${repo}.git" "-q --recursive"
=======
pushd .. 

for repo in "${REPOS[@]}"
do
    clone-if-not-present "git@github-personal:stubillwhite/${repo}.git"
>>>>>>> a7ca844 (OSX Sequoia migration)
done

popd
