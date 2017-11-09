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
	sudo easy_install pip
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


# Homebrew packages
read -r -d '' HOMEBREW_PACKAGES <<'END_HOMEBREW_PACKAGES'
awscli
cask
coreutils
darkmode
elasticsearch
go
htop
hub
icu4c
imagemagick
memcached
node
openssl
lua
readline
direnv
postgresql
redis
rust
speedtest_cli
the_silver_searcher
thefuck
tree
yarn
zeromq
END_HOMEBREW_PACKAGES

read -r -d '' PIP_MODULES <<'END_PIP_MODULES'


END_PIP_MODULES

read -r -d '' NODE_MODULES <<'END_NODE_MODULES'
osx-wifi-cli
END_NODE_MODULES
