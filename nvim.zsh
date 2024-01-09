# Default nvim profile
DEFAULT_NVIM_PROFILE="nvim/scratch"

# Install Bob
function setup_nvim() {
  # Install bob, the nvim version manager
  cargo install bob-nvim
}

alias nvimd="NVIM_APPNAME=nvim/default nvim $@"
alias nvimk="NVIM_APPNAME=nvim/kickstart nvim $@"
alias nvimn="NVIM_APPNAME=nvim/nvchad nvim $@"
alias nvimm="NVIM_APPNAME=nvim/scratch nvim $@"

function nvims() {
  items=("nvim/scratch" "nvim/default" "nvim/kickstart" "LazyVim" "nvim/nvchad" "AstroNvim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)

  # Check if the selected config is in the items array
  if [[ " ${items[*]} " == *" $config "* ]]; then
    # $config is in the array
    if [[ $config == "default" ]]; then
      nvim $@
    else
      NVIM_APPNAME=$config nvim $@
    fi
  else
    echo "Invalid selection"
    return 1
  fi
}
# https://thevaluable.dev/zsh-line-editor-configuration-mouseless/

bindkey -s ^n "nvims\n"

# Skip forward/back a word with opt-arrow
bindkey '[C' forward-word
bindkey '[D' backward-word

if which bob >/dev/null 2>&1; then
  # 'bob' is installed, add its directory to PATH
  export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
fi

export NVIM_APPNAME="${DEFAULT_NVIM_PROFILE}"
