#!/bin/env bash

declare -a queue
declare -a cargo_queue

function command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Define the function to accept multiple arguments
function add_dep() {
  for arg in "$@"; do
    queue+=("$arg")
  done
}

function add_rust_dep() {
  for arg in "$@"; do
    cargo_queue+=("$arg")
  done
}

# Generic function to deduplicate elements in an array
function dedupe() {
  local -n array=$1
  local -A seen
  local -a unique

  for item in "${array[@]}"; do
    if [[ -z ${seen[$item]} ]]; then
      unique+=("$item")
      seen[$item]=1
    fi
  done

  # Assign the unique elements back to the original array
  # array=("${unique[@]}")

  # Sort the array and assign it back to the original array
  IFS=$'\n' array=($(sort <<<"${unique[*]}"))
  unset IFS
}

function flush() {
  local -n array=$1
  array=()
}

## FASTER GIT STATUS FOR COMMAND PROMPTS
# https://github.com/romkatv/gitstatus

if $IS_MACOS; then
  # @see https://github.com/lra/mackup
  add_dep mackup

  # Mac App Store Client
  add_dep mas

  add_dep switchaudio-osx
fi

###
# Programming languages
###
add_dep rustup golang
add_dep lua luarocks
add_dep gcc

## JS things
add_dep nodejs yarn deno

##
# Databases and the like
##
add_dep elasticsearch mysql postgresql rabbitmq redis sqlite zeromq

## Add things for the shell
add_dep bash bash-completion zsh starship

# Gets the pid of a process
# http://www.nightproductions.net/cli.htm
add_dep pidof

add_dep fzf ripgrep fd the_silder_searcher bat lsd glow zoxide zellij wget

# Add git things
add_dep git git-lfs gh hub lazygit

# Add json cli
add_dep jq

# Error correction
add_dep thefuck

# INSTALL
# Next, we're going to install from diffrent package managers

# [F]ast [N]ode [M]anager
# Changes versions of nodejs quickly
add_rust_dep fnm

# Shouldn't we install this locally?
add_rust_dep stylua

# Version manager for nvim
add_rust_dep bob

# Better LS
add_rust_dep eza

# Better ls
add_dep lsd tree

# Processes
add_dep htop btop

# autoconf
# automake
# harfbuzz # do I need this?
# tree-sitter

add_dep heroku

# echo "Before deduplication: ${queue[@]}"

# dedupe queue
# echo "After deduplication: ${queue[@]}"

function install_homebrew() {
  # local arch_deps = base-devel procps-ng curl file git
  # local debian_deps = build-essential procps curl file git

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

if $IS_MACOS; then
  if ! command_exists brew; then
    echo install_homebrew
  fi

  dedupe queue
  echo brew update
  echo brew install "${queue[@]}"
fi

# # Cleanup after ourselves
# unset install_homebrew
