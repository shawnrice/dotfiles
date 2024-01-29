#!/bin/bash

# This needs to be reworked. But the idea is that I can do a minimal install and read this from
# github

IS_MACOS=$(uname -a | grep Darwin)  # This was done by copilot... check this
IS_LINUX=$(uname -a | grep Linux)   # This was done by copilot... check this
IS_WSL=$(uname -a | grep Microsoft) # This was done by copilot... check this

function source_if_exists() {
  if [ -f "$1" ]; then
    source "$1"
  fi
}

echo "Install script is broken..."
echo "Please rewrite it before using it again"
echo ""

return 1

source functions.sh
source aliases.sh
source path.sh

############
### Versions
############

NVM_VERSION='v0.33.6'

function else_run() {
  if [[ -z $(command -v $1) ]]; then
    eval $2
  fi
}

# Install catlight
# https://catlight.io/downloads

function install_rust() {
  # https://www.rust-lang.org/tools/install
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

# install up
function install_up() {
  # https://github.com/shannonmoeller/up
  curl --create-dirs -o ~/.config/up/up.sh https://raw.githubusercontent.com/shannonmoeller/up/master/up.sh
}

function install_fnm() {
  # https://github.com/Schniz/fnm
  curl -fsSL https://fnm.vercel.app/install | bash --skip-shell
  # Or use cargo: cargo install fnm

  # Add to shell once...
  # eval "$(fnm env --use-on-cd)"
}

function install_homebrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  brew update
}

function install_pip() {
  # Pip is not installed by default
  sudo easy_install pip
  # Pip is likely to be a an older version, so we'll immediately upgrade
  sudo pip install --upgrade pip
}

function use_zsh() {
  chsh -s /bin/zsh
}

function install_zgen() {
  git clone --depth 1 https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
}

function install_iterm_shell_integration() {
  # curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh
}

# Install Homebrew if it doesn't exist
else_run "brew" "install_homebrew"

# Install Up if it doesn't exist
else_run "up" "install_up"

# Install Rust if it doesn't exist
else_run "cargo" "install_rust"

# Install fnm if it doesn't exist
else_run "fnm" "install_fnm"

# Install pip
else_run "pip" "install_pip"

# At this point, we need to install the brewfiles
brew bundle

read -r -d '' PIP_MODULES <<'END_PIP_MODULES'
Pygments
CodeIntel
powerline-shell
END_PIP_MODULES

# read -r -d '' NODE_MODULES <<'END_NODE_MODULES'
# cost-of-modules
# osx-wifi-cli
# END_NODE_MODULES

pip install --user $PIP_MODULES
[[ -z $NODE_MODULES ]] && npm install -g $NODE_MODULES

# Symlink Sublime CLI if it doesn't exist
# [[ -z $(command -v subl) ]] && sudo ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/bin/subl
# [[ -z $(command -v subl) ]] && sudo ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/bin/subl

for f in $(find macos -name "*.sh"); do
  bash "$f"
done

use_zsh

# Install a terminal
# Install WezTerm
# Link wezterm config
# ln -s
