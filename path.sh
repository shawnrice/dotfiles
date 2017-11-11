# # Add other bins, includes homebrew, global npm packages
# PATH="/usr/local/bin:${PATH}"
# PATH="/usr/local/sbin:${PATH}"

# # Add general ruby
# PATH="${PATH}:${HOME}/.gem/ruby/2.0.0/bin"

# # Add rust commands
# PATH="${PATH}:${HOME}/.cargo/bin"

# # Add globally installed composer packages
# PATH="${PATH}:${HOME}/.composer/vendor/bin"

# PATH="$PATH:$HOME/Library/Python/2.7/bin/"

# Pull in all the things that we need
read -r -d '' PATH_SEGMENTS <<END_PATH_SEGMENTS
/usr/local/bin
/usr/local/sbin
$HOME/.gem/ruby/2.0.0/bin
$HOME/.cargo/bin
$HOME/.composer/vendor/bin
$HOME/Library/Python/2.7/bin
END_PATH_SEGMENTS

# Join the paths together and spit them out as one
export PATH=$(echo $PATH_SEGMENTS | tr ' ' ':')
