#!/bin/bash 

# Configure defaults
#
# See https://macos-defaults.com/
#
# defaults domains      # List domains
# defaults find WORD    # Search for WORD

function configure-setting-if-exists() {
    local domain=$1
    local key=$2
    shift
    shift
    local value=$*

    echo "${domain} ${key} ${value}"
    if defaults read "${domain}" "${key}" > /dev/null 2>&1 ; then 
        echo "Old setting: " $(defaults read "${domain}" "${key}")
        defaults write "${domain}" "${key}" ${value}
        echo "New setting: " $(defaults read "${domain}" "${key}")
    else 
        echo "Setting '${domain}' ${key} not found"
    fi
    echo
}

function configure-setting() {
    local domain=$1
    local key=$2
    shift
    shift
    local value=$*

    echo "${domain} ${key} ${value}"
    defaults write "${domain}" "${key}" ${value}
    echo "New setting: " $(defaults read "${domain}" "${key}")
    echo
}

function configure-osx-preferences() {
    echo 'Configuring OSX preferences'

    # UI minimum is 15, but 10 can be configured (though a reboot is required for this to take effect)
    echo "- Keyboard repeat should start instantly"
    configure-setting-if-exists 'Apple Global Domain' InitialKeyRepeat -int 15

    # UI minimum is 2, but 1 can be configured (though a reboot is required for this to take effect)
    echo "- Keyboard repeat should be as fast as possible"
    configure-setting-if-exists 'Apple Global Domain' KeyRepeat -int 1

    echo "- AppSwitcher should display on all monitors"
    configure-setting com.apple.dock appswitcher-all-displays -bool true

    echo "- Operating system should be silent"
    configure-setting-if-exists 'Apple Global Domain' com.apple.sound.beep.flash      -int 0
    configure-setting-if-exists 'Apple Global Domain' com.apple.sound.uiaudio.enabled -int 0
    configure-setting-if-exists 'Apple Global Domain' com.apple.sound.beep.volume     -int 0

    echo "- Reduce transparency"
    configure-setting-if-exists com.apple.universalaccess reduceTransparency -int 1

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
    # defaults write com.apple.dock wvous-tl-corner   -int 0
    # defaults write com.apple.dock wvous-tl-modifier -int 0
    # defaults write com.apple.dock wvous-tr-corner   -int 0
    # defaults write com.apple.dock wvous-tr-modifier -int 0
    # defaults write com.apple.dock wvous-bl-corner   -int 0
    # defaults write com.apple.dock wvous-bl-modifier -int 0
    configure-setting-if-exists com.apple.dock wvous-br-corner   -int 13 
    configure-setting-if-exists com.apple.dock wvous-br-modifier -int 1048576

    # echo
    echo "Killing affected applications"

    APPS=(
        "Finder"
        "SystemUIServer"
        "Sound"
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
