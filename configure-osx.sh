#!/bin/bash 

# Configure defaults
#
# See https://macos-defaults.com/
#
# defaults domains      # List domains
# defaults find WORD    # Search for WORD

function msg-success() {
    local msg=$1
    printf "${CLEAR_LINE}${COLOR_GREEN}✔ ${msg}${COLOR_NONE}\n"
}

function msg-error() {
    local msg=$1
    printf "${CLEAR_LINE}${COLOR_RED}✘ ${msg}${COLOR_NONE}\n"
}

function configure-setting-if-present() {
    local domain=$1
    local key=$2
    shift
    shift
    local values=$*

    if defaults read "${domain}" "${key}" > /dev/null; then
        defaults write "${domain}" "${key}" ${values}
    else
        msg-error "Setting ${domain} ${key} does not exist"
    fi
}

function configure-osx-preferences() {
    echo 'Configuring OSX preferences'

    echo "- Keyboard repeat should start instantly"
    configure-setting-if-present NSGlobalDomain InitialKeyRepeat -int 15

    echo "- Keyboard repeat should be as fast as possible"
    configure-setting-if-present NSGlobalDomain KeyRepeat -int 1

    echo "- AppSwitcher should display on all monitors"
    configure-setting-if-present com.apple.dock appswitcher-all-displays -bool true

    echo "- Operating system should be silent"
    configure-setting-if-present com.apple.sound.beep.flash      -int 0
    configure-setting-if-present com.apple.sound.beep.volume     -int 0
    configure-setting-if-present com.apple.sound.uiaudio.enabled -int 0

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
    configure-setting-if-present com.apple.dock wvous-tl-corner   -int 0
    configure-setting-if-present com.apple.dock wvous-tl-modifier -int 0
    configure-setting-if-present com.apple.dock wvous-tr-corner   -int 0
    configure-setting-if-present com.apple.dock wvous-tr-modifier -int 0
    configure-setting-if-present com.apple.dock wvous-bl-corner   -int 0
    configure-setting-if-present com.apple.dock wvous-bl-modifier -int 0
    configure-setting-if-present com.apple.dock wvous-br-corner   -int 13 
    configure-setting-if-present com.apple.dock wvous-br-modifier -int 1048576

    # Add pathbar to title
    echo "- Finder should display path in title"
    configure-setting-if-present com.apple.finder _FXShowPosixPathInTitle -bool true

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
