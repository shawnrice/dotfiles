# autoload bashcompinit
# bashcompinit

# FPATH="${DOTS}/zellij/completions.zsh:${FPATH}"
FPATH="${DOTS}/zellij:${FPATH}"

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

if type docker &>/dev/null; then
  FPATH="${DOTS}/zsh/docker_completions.zsh:${FPATH}"
fi

# autoload -Uz compinit
# compinit

# Load and initialize the completion system ignoring insecure directories with a
# cache time of 20 hours, so it should almost always regenerate the first time a
# shell is opened each day.
autoload -Uz compinit
# compinit -i -C -d "${ZIM_HOME}/state/.zcompdump"
