# Alias `git` to `hub`
# https://github.com/github/hub
eval_if_command_exists hub "$(hub alias -s)"

# Directory based environments NOTE LOAD AFTER RVM AND PROMPT
# https://github.com/direnv/direnv
eval_if_command_exists direnv "$(direnv hook bash)"
eval_if_command_exists thefuck $(thefuck --alias f)


# Load Node Version Manager
source_if_exists "${HOME}/.nvm/nvm.sh"
# Load up
source_if_exists "${HOME}/.config/up/up.sh"
# Load Ruby Version Manager
source_if_exists "${HOME}/.rvm/scripts/rvm"

alias updatedb='sudo /usr/libexec/locate.updatedb'
alias git='hub'

# alias the Simulator
alias ios="open '/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app'"

# ls alias for color-mode
alias lh='ls -lhaG'


# grep with color
alias grep='grep -in --color=auto'

# refresh shell
alias reload='source ~/.bash_profile'

# Directory colors
LS_COLORS=$LS_COLORS:'di=0;35:'
export LS_COLORS

alias gpg-refresh='gpg --refresh-keys'
alias brewup='brew update && brew upgrade && brew prune && brew cleanup && brew doctor'

# Brew, remove the entire tree using 'beeftornado/rmtree'
alias "brew rm"='brew rmtree'

alias wifi='osx-wifi-cli'

# /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash