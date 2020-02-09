#!/bin/bash

function execute-command() {
    local file=$1

    if [[ -s "${file}" ]]; then
        echo "Checking ${file}"
        brew bundle --file="${file}" install --verbose
        echo 
    fi
}

execute-command "Brewfile"
execute-command "Brewfile.$(uname -n)"
