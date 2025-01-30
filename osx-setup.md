# osx-setup #

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
## Table of contents ##

- [osx-setup](#osx-setup)
    - [Prerequisites](#prerequisites)
    - [Bootstrap and configure](#bootstrap-and-configure)
    - [Configure OSX](#configure-osx)
    - [Configure tools](#configure-tools)
        - [iTerm2](#iterm2)
        - [Raycast](#raycast)

<!-- markdown-toc end -->

## Prerequisites ##

- Get homebrew
    - [Homebrew — The Missing Package Manager for macOS (or Linux)](https://brew.sh/)
- Install Git
    - `brew install git`
- Create my space
    - `mkdir -p ~/dev/my-stuff`
- Install `dotfiles`
    - `cd ~/dev/my-stuff`
    - `git clone git@github.com:stubillwhite/dotfiles.git`
    - `cd dotfiles`
    - `./bootstrap.sh`

## Bootstrap and configure ##

- Install SSH keys
    - These are in your key vault and live in `~/.ssh/keys`
- Install packages
    - `cd ~/dev/my-stuff/dotfiles/homebrew`
    - `./install`
- Clone everything else
    - `cd ~/dev/my-stuff/dotfiles`
    - `./clone-active-repos.sh`
- Install global tools
    - `cd ~/dev/my-stuff/dotfiles`
    - `./install-global-npm-packages.sh`
    - `./install-global-pipx-packages.sh`
- Configure NVim
    - `nvim`
    - `:PlugInstall`
    - TODO: Install compatible Python version

## Configure OSX ##

### Automated settings ###

- Configure settings
    - `cd ~/dev/my-stuff/dotfiles`
    - `./configure-osx.sh`
    - Restart

### Manual settings ###

- `System Settings` > `Keyboard` > `Keyboard Shortcutske`
    - Turn off everything except:
        - `Keyboard` > `Move focus to next window`
        - `Screenshots` > Everything, except `Screenshot and recording options`
    - `Function Keys`
        - Enable using function keys as standard function keys
    - `Modifier Keys`
        - Change `Caps Lock` to `Control`

- `System Settings` > `Keyboard` > `Shortcuts` > `App Shortcuts`
    - Define new shortcuts for each of the following, which should match exactly what you see in the Apple menu:
        - `Log Out`
        - `Log Out Stu White…` (`alt-;` to enter `…`)
        - `Lock Screen`
    - Create the shortcuts with the following settings:
        - Application: All Applications
        - Menu title: (see above)
        - Keyboard shortcut: (something you'll never use, like `Cmd-shift-§`)
    - Log out and in again

## Configure tools ##

### iTerm2 ###

- iTerm2 > Settings
- In the General tab select > Settings
- `Import All Settings and Data...`
- Load from `~/dev/dotfiles/iterm2`

### Raycast ###

- TODO: Settings

