# Yarn paths - add if directories exist (yarn may be managed by fnm/corepack)
[[ -d "$HOME/.yarn/bin" ]] && export PATH="$HOME/.yarn/bin:$PATH"
[[ -d "$HOME/.config/yarn/global/node_modules/.bin" ]] && export PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"
