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

- Configure settings
    - `cd ~/dev/my-stuff/dotfiles`
    - `./configure-osx.sh`
    - Restart
    - TODO: Manual steps

## Configure tools ##

### iTerm2 ###

- iTerm2 > Settings
- In the General tab select > Settings
- `Import All Settings and Data...`
- Load from `~/dev/dotfiles/iterm2`

### Raycast ###

- TODO: Settings

