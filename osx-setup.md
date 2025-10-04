# osx-setup #

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
## Table of contents ##

- [osx-setup](#osx-setup)
    - [Prerequisites](#prerequisites)
    - [Bootstrap and configure](#bootstrap-and-configure)
    - [Configure OSX](#configure-osx)
        - [Automated settings](#automated-settings)
        - [Manual settings](#manual-settings)
    - [Configure tools](#configure-tools)
        - [AWS](#aws)
        - [DBeaver](#dbeaver)
        - [Firefox](#firefox)
        - [IntelliJ and PyCharm](#intellij-and-pycharm)
        - [iTerm2](#iterm2)
        - [Mailmap](#mailmap)
        - [NVim](#nvim)
        - [Obsidian](#obsidian)
        - [Outlook](#outlook)
        - [Raycast](#raycast)
        - [ScrollReverser](#scrollreverser)
        - [Visual Studio Code](#visual-studio-code)

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
    - Link default keys to the SSH directory
        - `cd ~/.ssh`
        - `ln -s ~/.ssh/keys/id_rsa`
        - `ln -s ~/.ssh/keys/id_rsa.pub`
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
- Install `prezto`
    - `cd ~/dev/my-stuff/prezto`
    - `./bootstrap.sh`

## Configure OSX ##

### Automated settings ###

- Configure settings
    - `cd ~/dev/my-stuff/dotfiles`
    - `./configure-osx.sh`
    - Restart

### Manual settings ###

- `System Settings`
    - `Accessibility`
        - `Display`
            - `Reduce transparency`
    - `Keyboard`
        - `Keyboard Shortcuts`
            - Turn off everything except:
                - `Keyboard` > `Move focus to next window`
                - `Screenshots` > Everything, except `Screenshot and recording options`
            - `Function Keys`
                - Enable using function keys as standard function keys
            - `Modifier Keys`
                - Change `Caps Lock` to `Control`
        - `Dictation`
            - Change `Shortcut` to `Press Microphone`

        - `Shortcuts` > `App Shortcuts`
            - Define new shortcuts for each of the following, which should match exactly what you see in the Apple menu:
                - `Log Out`
                - `Log Out Stu White…` (`alt-;` to enter `…`)
                - `Lock Screen`
            - Create the shortcuts with the following settings:
                - Application: All Applications
                - Menu title: (see above)
                - Keyboard shortcut: (something you'll never use, like `Cmd-shift-§`)
            - Log out and in again

    - `Sound`
        - Disable `Play user interface sound effects`

## Configure tools ##

### AWS ###

- `~/.aws/config` configuration is in your key vault

### DBeaver ###

- Install project configuration
    - This is in your key vault and is loaded in `File` > `Import` > `DBeaver Project`

### Firefox ###

- Browse to https://kagi.com/
- Right-click in the address bar and choose `Add "Kagi Search"`
- `Firefox` > `Settings` > `Search`
- Change the shortcut to `@kagi`

Possibly need to set `security.external_protocol_requires_permission` in `about:config` to false to enable Emacs
org-mode protocol to run without prompting.

### IntelliJ and PyCharm ###

- `Settings` 
    - `Version Control` > `Commit`
        - Disable `Use non-modal commit interface`
    - `Editor` > `General` > `Appearance`
        - Disable `Show hard wrap and visual guides`
        - Enable `Compact mode`

To enable the old-style Git commit interface:

- `Settings`
    - `Advanced Settings` 
        - `Enable commit tool window`
            - Disable to merge the "commit" and "Git" panels and restores the "preview diff" toggle button for the panel
        - `Toggle Commit Controls`
            - Enable to add a "commit" button to the panel which toggles the per-file Git commit checkboxes and commit
              message box in-place
    - `Version Control` > `GitHub` > `Enable Staging Area`
        - Disable to display your uncommited changes as a single list instead of staged/unstaged
  
- Open the `Git` panel
    - Set the view mode to "windowed" if desired
    - Enable "Preview Diff"

### iTerm2 ###

- iTerm2 > Settings
- In the General tab select > Settings
- `Import All Settings and Data...`
- Load from `~/dev/dotfiles/iterm2`

### Mailmap ###

- Install configuration
    - This is in your key vault and lives in `~/.mailmap`

### NVim ###

- `cd ~/dev/my-stuff/nvim`
- `./bootstrap.sh`
- Run NVim with `nvim` then type `:PlugInstall` to install plugins
- `pushd ~/.config/vim-plug/YouCompleteMe`
- `./install.py`

### Obsidian ###

- Run Obsidian
- Open the vault at `~/Dropbox/Private/obsidian`

### Outlook ###

- Run Outlook
- `Outlook` > `Settings...`
    - `General` 
        - Enable compact view
        - Disable transparency
    - `Reading` 
        - Mark email as read only after five seconds
        - Disable focused inbox
    - `Composing` > Set wait to send messages to the maximum
    - `Calendar`
        - Second timezone `-5:00` EST
        - Third timezone `+5:30` India
        - Turn off weather
- Go to Calendar
    - `View` > `Timescale` > 12 hours

### Raycast ###

- Run Raycast
- `Cmd-,` to open settings > Advanced > Import
- Import from `~/dev/dotfiles/raycast`

### ScrollReverser ###

- Run ScrollReverser and grant permissions when prompted

### Visual Studio Code ###

- Run Visual Studio Code
- `Code` > `Settings...` > `Settings`
    - Search for `Sticky Scroll` and set `Editor: Sticky Scroll` to disabled
