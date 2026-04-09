# dotfiles

This repo holds my shell profile and CLI settings. I use bash on both linux and macOS and I work with backend development and infrastructure in GCP, so most tools are related to that.

The main purpose of this repo is to keep track of what I install and configure on my systems. If you find anything useful here, feel free to fork it.

## bash

```bash
export LANG="${LANG:-en_US.UTF-8}"
export LC_CTYPE="${LC_CTYPE:-$LANG}"
if [[ -n "${LC_COLLATE+x}" && -z "${LC_COLLATE}" ]]; then
  unset LC_COLLATE
fi

[[ $- != *i* ]] && return
PS1='\w$ '

export HISTSIZE=1000
export HISTFILESIZE=1000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

if type direnv &>/dev/null
then
  eval "$(direnv hook bash)"
fi

if type fnm &>/dev/null
then
  eval "$(fnm env --shell bash --use-on-cd)"
fi

if type gcloud &>/dev/null
then
  source "$(brew --prefix)/share/google-cloud-sdk/path.bash.inc"
  source "$(brew --prefix)/share/google-cloud-sdk/completion.bash.inc"
fi

if type rbenv &>/dev/null
then
  eval "$(rbenv init - bash)"
fi

if type brew &>/dev/null; then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # bash-completion@2
  if [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]]; then
    . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
  fi
fi
```

## git+ssh

1. Generate keys
```shell
ssh-keygen
```
2. Create `~/.gitconfig`
```gitconfig
[init]
  defaultBranch = main
[push]
  default = current
[commit]
  gpgsign = true
[gpg]
  format = ssh
[user]
  signingkey = ~/.ssh/id_ed25519.pub
  name = Alexander Czigler
  email = 3116043+alexanderczigler@users.noreply.github.com
```

## apps

### macOS

1. Install [Homebrew](https://brew.sh/)
2. Install apps
```shell
brew install \
 bash \
 bash-completion@2 \
 bitwarden \
 bruno \
 colima \
 direnv \
 docker \
 docker-buildx \
 docker-compose \
 firefox \
 fluxcd/tap/flux \
 fnm \
 gh \
 git \
 go \
 font-fira-code \
 google-cloud-sdk \
 jq \
 kubectl \
 kubectx \
 microsoft-edge \
 obs \
 obsidian \
 protobuf@33 \
 rbenv \
 tw93/tap/kakuku \
 visual-studio-code \
 watch \
 yq
```
3. Configure gcloud
```shell
gcloud --quiet components install beta gke-gcloud-auth-plugin
```
4. Fix proper mouse support
```shell
softwareupdate --install-rosetta --agree-to-license
brew install sensiblesidebuttons unnaturalscrollwheels
```

### SensibleSideButtons

[SensibleSideButtons](https://sensible-side-buttons.archagon.net) will let you use the side buttons on a mouse just like in Linux or Windows. Once installed, add it to `Login items` in System Settings.

> Once installed, add it to `Login items` in System Settings.

### UnnaturalScrollWheels

[UnnaturalScrollWheels](https://github.com/ther0n/UnnaturalScrollWheels) lets you configure a _normal_ scroll direction on the wheel of a mouse, while keeping the _natural_ scroll direction on your trackpad. I love it!

> Once installed, add it to `Login items` in System Settings.

#### Configuration

![unnaturalscrollwheels](https://github.com/alexanderczigler/dotfiles/assets/3116043/b9b52edc-c7ea-4bcc-82ad-a66676784150)

### hidutil

Remap `<` and `§` on my non-Apple keyboard.

#### Change this session only

```shell
sudo hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035},{"HIDKeyboardModifierMappingSrc":0x700000035,"HIDKeyboardModifierMappingDst":0x700000064}]}'
```

#### Persist change after reboot

Edit `~/Library/LaunchAgents/com.local.KeyRemapping.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.local.KeyRemapping</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/hidutil</string>
        <string>property</string>
        <string>--set</string>
        <string>{"UserKeyMapping":[

            {
              "HIDKeyboardModifierMappingSrc": 0x700000064,
              "HIDKeyboardModifierMappingDst": 0x700000035
            },

            {
              "HIDKeyboardModifierMappingSrc": 0x700000035,
              "HIDKeyboardModifierMappingDst": 0x700000064
            }

        ]}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
```
