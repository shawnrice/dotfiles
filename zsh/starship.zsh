if ! command_exists starship; then
  echo "[WARN]: starship is not installed. Skipping starship configuration."
  return 0
fi

# Add a fast prompt
eval "$(starship init zsh)"
