# Alias `git` to `hub`
# https://github.com/github/hub
command_exists hub && eval "$(hub alias -s)"

# Directory based environments NOTE LOAD AFTER RVM AND PROMPT
# https://github.com/direnv/direnv
command_exists direnv && eval "$(direnv hook bash)"

# Alias command correction to `f`
command_exists thefuck && eval "$(thefuck --alias f)"

# Load Node Version Manager
source_if_exists "${HOME}/.nvm/nvm.sh"
# Load up
source_if_exists "${HOME}/.config/up/up.sh"
# Load Ruby Version Manager
source_if_exists "${HOME}/.rvm/scripts/rvm"

# This should exist but doesn't
alias updatedb='sudo /usr/libexec/locate.updatedb'

# Change git to use hub
alias git='hub'

# alias the Simulator
alias ios="open '/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app'"

# ls alias for color-mode
alias lh='ls -lhaG'

# grep with color
alias grep='grep -in --color=auto'

# refresh shell
alias reload='source ~/.bash_profile'

alias gpg-refresh='gpg --refresh-keys'
alias brewup='brew update && brew upgrade && brew prune && brew cleanup && brew doctor'

# Brew, remove the entire tree using 'beeftornado/rmtree'
alias brewrm='brew rmtree'

alias wifi='osx-wifi-cli'

# /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash

# Directory colors
LS_COLORS=$LS_COLORS:'di=0;35:'
export LS_COLORS
