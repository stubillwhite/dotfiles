#!/bin/bash 

function configure-osx-preferences() {
    echo 'Configuring OSX preferences'

    echo "- Keyboard repeat should start instantly"
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    echo "- Keyboard repeat should be as fast as possible"
    defaults write NSGlobalDomain KeyRepeat -int 1

    echo "- AppSwitcher should display on all monitors"
    defaults write com.apple.dock appswitcher-all-displays -bool true

    # Hot corners
    # Possible values:
    #  0: no-op
    #  2: Mission Control
    #  3: Show application windows
    #  4: Desktop
    #  5: Start screen saver
    #  6: Disable screen saver
    #  7: Dashboard
    # 10: Put display to sleep
    # 11: Launchpad
    # 12: Notification Center
    # 13: Lock Screen
    echo "- Hot corners should allow Cmd+BottomRight to lock screen"
    defaults write com.apple.dock wvous-tl-corner   -int 0
    defaults write com.apple.dock wvous-tl-modifier -int 0
    defaults write com.apple.dock wvous-tr-corner   -int 0
    defaults write com.apple.dock wvous-tr-modifier -int 0
    defaults write com.apple.dock wvous-bl-corner   -int 0
    defaults write com.apple.dock wvous-bl-modifier -int 0
    defaults write com.apple.dock wvous-br-corner   -int 13 
    defaults write com.apple.dock wvous-br-modifier -int 1048576

    echo
    echo "Killing affected applications"

    APPS=(
        "Finder"
        "SystemUIServer"
        "Dock"
    )

    for app in "${APPS[@]}"; do
        echo "- ${app}"
        killall "$app" >/dev/null 2>&1
    done

    echo
    echo "Note that some settings require a restart to take effect"
}

configure-osx-preferences
