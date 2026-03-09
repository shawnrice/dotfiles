function zr() { zellij run --name "$*" -- zsh -ic "$*"; }
function zrf() { zellij run --name "$*" --floating -- zsh -ic "$*"; }
function zri() { zellij run --name "$*" --in-place -- zsh -ic "$*"; }
function ze() { zellij edit "$*"; }
function zef() { zellij edit --floating "$*"; }
function zei() { zellij edit --in-place "$*"; }
function zpipe() {
  if [ -z "$1" ]; then
    zellij pipe
  else
    zellij pipe -p $1
  fi
}

function zj() {
  if [ -n "$1" ]; then
    zellij attach "$1" -c
  else
    local session=$(zellij list-sessions -s 2>/dev/null | fzf --prompt="session: ")
    if [ -n "$session" ]; then
      zellij attach "$session"
    else
      zellij
    fi
  fi
}
