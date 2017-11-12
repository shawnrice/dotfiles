#!/bin/bash

############
### Versions
############

NVM_VERSION='v0.33.6'

function else_run() {
	[[ -z command -v $1 ]] && $2
}

# Install catlight
# https://catlight.io/downloads

# install up
function install_up() {
	# https://github.com/shannonmoeller/up
	curl --create-dirs -o ~/.config/up/up.sh https://raw.githubusercontent.com/shannonmoeller/up/master/up.sh
}

# Install nvm
function install_nvm() {
	# https://github.com/creationix/nvm
	curl -o- "https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh" | bash
}

function install_rvm() {
	# https://rvm.io/
	gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
	\curl -sSL https://get.rvm.io | bash -s stable
}

function install_homebrew() {
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew update
}

function intall_pip() {
	# Pip is not installed by default
	sudo easy_install pip
	# Pip is likely to be a an older version, so we'll immediately upgrade
	sudo pip install --upgrade pip
}

# Install Homebrew if it doesn't exist
else_run brew install_homebrew
# Install Up if it doesn't exist
else_run up install_up
# Install NVM if it doesn't exist
else_run nvm install_nvm
# Install rvm if it doesn't exist
else_run rvm install_rvm

# At this point, we need to install the brewfiles
brew bundle

read -r -d '' PIP_MODULES <<'END_PIP_MODULES'
Pygments
CodeIntel
powerline-shell
END_PIP_MODULES

read -r -d '' NODE_MODULES <<'END_NODE_MODULES'
cost-of-modules
osx-wifi-cli
END_NODE_MODULES

pip install --user $PIP_MODULES
npm install -g $NODE_MODULES

# Symlink Sublime CLI
sudo ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/bin/subl