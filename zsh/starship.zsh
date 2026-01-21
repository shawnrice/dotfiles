# Starship prompt - cached for speed (regenerates if binary changes)
if command_exists starship; then
  _starship_cache="${XDG_CACHE_HOME:-$HOME/.cache}/starship_init.zsh"
  _starship_bin="$(command -v starship)"
  if [[ ! -f "$_starship_cache" || "$_starship_bin" -nt "$_starship_cache" ]]; then
    starship init zsh > "$_starship_cache"
  fi
  source "$_starship_cache"
  unset _starship_bin _starship_cache
fi
