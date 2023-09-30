#!/bin/bash 

function configure-osx-preferences() {
    echo 'Configuring OSX preferences'

    echo "Keyboard repeat should start instantly"
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    echo "Keyboard repeat should be as fast as possible"
    defaults write NSGlobalDomain KeyRepeat -int 1

    echo "AppSwitcher should display on all monitors"
    defaults write com.apple.dock appswitcher-all-displays -bool true

    echo "Killing affected applications"
    for app in Finder SystemUIServer; do killall "$app" >/dev/null 2>&1; done
    killall Dock
}

configure-osx-preferences
