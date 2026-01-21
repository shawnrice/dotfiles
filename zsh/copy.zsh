# Clipboard functions (cross-platform)

function clipcopy() {
  if [[ $OSTYPE == darwin* ]]; then
    pbcopy
  elif [[ -n $WAYLAND_DISPLAY ]]; then
    wl-copy
  elif [[ -n $DISPLAY ]]; then
    xclip -selection clipboard
  fi
}

function clippaste() {
  if [[ $OSTYPE == darwin* ]]; then
    pbpaste
  elif [[ -n $WAYLAND_DISPLAY ]]; then
    wl-paste
  elif [[ -n $DISPLAY ]]; then
    xclip -selection clipboard -o
  fi
}

# Copies the path of given directory or file to the system clipboard.
# Copy current directory if no parameter.
function copypath {
  # If no argument passed, use current directory
  local file="${1:-.}"

  # If argument is not an absolute path, prepend $PWD
  [[ $file = /* ]] || file="$PWD/$file"

  # Copy the absolute path without resolving symlinks
  # If clipcopy fails, exit the function with an error
  print -n "${file:a}" | clipcopy || return 1

  echo ${(%):-"%B${file:a}%b copied to clipboard."}
}

# Copies the contents of a given file to the system or X Windows clipboard
#
# copyfile <file>
function copyfile {
  emulate -L zsh
  clipcopy $1
}
