# Navigation
alias projects="cd ${HOME}/projects"
alias p="projects"
alias dotfiles="cd ${HOME}/projects/dotfiles"

# Config editing
alias zshconfig="$EDITOR ~/.zshrc"

# Git
alias gco="git checkout"

# Modern replacements (conditional)
command -v eza &>/dev/null && alias ls="eza" && alias ll="eza -la" && alias la="eza -a" && alias tree="eza --tree"
