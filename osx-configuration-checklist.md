# OSX configuration checklist #

Last tested on OSX Sequoia

## Clone ##

- Manually clone `stubillwhite/dotfiles`
- `./bootstrap.sh`
- `./clone-active-repos.sh`
- `./install-global-npm-packages.sh`
- `./install-global-pipx-packages.sh`

## Configure Raycast ##

## Disable OSX system shortcuts ##

- `System Settings` > `Keyboard` > `Shortcuts` > `App Shortcuts`
    - Define new shortcuts for each of the following, which should match exactly what you see in the Apple menu:
        - `Log Out`
        - `Log Out Stu White…` (`alt-;` to enter `…`)
        - `Lock Screen`
    - Create the shortcuts with the following settings:
        - Application: All Applications
        - Menu title: (see above)
        - Keyboard shortcut: (something you'll never use)
    - Log out and in again
