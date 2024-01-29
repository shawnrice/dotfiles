# This should work for arch, ubuntu, and macos to download and install the necessary dependencies

function install_homebrew() {
  local arch_deps = base-devel procps-ng curl file git
  local debian_deps = build-essential procps curl file git

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

# Cleanup after ourselves
unset install_homebrew
