# Neovim configuration

# Bob (nvim version manager)
if command_exists bob; then
  export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
fi

function setup_nvim() {
  cargo install bob-nvim
}
