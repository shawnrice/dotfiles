# Add other bins, includes homebrew, global npm packages
PATH="/usr/local/bin:${PATH}"
PATH="/usr/local/sbin:${PATH}"

# Add general ruby
PATH="${PATH}:${HOME}/.gem/ruby/2.0.0/bin"

# Add rust commands
PATH="${PATH}:${HOME}/.cargo/bin"

# Add globally installed composer packages
PATH="${PATH}:${HOME}/.composer/vendor/bin"

# Add in python commands
PATH="$PATH:$HOME/Library/Python/2.7/bin/"

# Add in Up
PATH="$PATH:$HOME/.config/up"
