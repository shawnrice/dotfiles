# @shawnrice's dotfiles

Configuration files for macOS and Arch

## What's Included

- **zsh** - Shell with zim framework
- **git** - Platform-specific configs (`.gitconfig.macos`, `.gitconfig.linux`)
- **nvim** - Neovim configuration
- **ghostty** - Terminal emulator
- **zellij** - Terminal multiplexer
- **bat, lazygit, btop** - CLI tools
- **nix** - Package manager

## Installation

```bash
git clone https://github.com/shawnrice/dotfiles.git ~/projects/dotfiles
ln -sf ~/projects/dotfiles/.zshrc ~/.zshrc
ln -sf ~/projects/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/projects/dotfiles/nvim/zeta.nvim ~/.config/nvim/zeta.nvim
```

Launch nvim with:
```bash
NVIM_APPNAME=zeta.nvim nvim
```

Or add an alias to your `.zshrc`:
```bash
alias zeta='NVIM_APPNAME=zeta.nvim nvim'
```
