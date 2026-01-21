# macOS-specific configuration

if [[ $OSTYPE != darwin* ]]; then
  return 0
fi

# WezTerm CLI tools
if [[ -d /Applications/WezTerm.app/Contents/MacOS ]]; then
  export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
fi

# Homebrew utilities
if command_exists brew; then
  function brewup() {
    brew update && brew upgrade && brew upgrade --cask && brew doctor && brew cleanup
  }
fi
