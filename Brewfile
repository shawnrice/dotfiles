# See https://github.com/Homebrew/homebrew-bundle
cask_args appdir: "/Applications"

# Tap a few things first
tap "homebrew/bundle"
tap "homebrew/core"
tap "homebrew/services"
tap "beeftornado/rmtree"

# Tap some casks
tap "caskroom/cask"
tap "caskroom/fonts"

# Some core things / dependencies
brew "autoconf"
brew "automake"
brew "boost"
brew "coreutils"
brew "highlight"
brew "icu4c"
brew "libevent"
brew "libsodium"
brew "libtool"
brew "libyaml"
brew "pcre"
brew "pkg-config"

# Languages
brew "go"
brew "lua"
brew "node"
brew "rust"

# Databases / MQs / Cache Layers
brew "czmq"
brew "elasticsearch"
brew "memcached"
brew "mongodb"
brew "mysql" # upgrade mysql
brew "postgresql", restart_service: true
brew "redis"
brew "sqlite"
brew "zeromq"

# Webservers
brew "nginx"

#######
# Media
#######

# Images
brew "imagemagick"
# Image optimization
brew "jpeg-archive"
brew "jpegoptim"
brew "pngcrush"
brew "pngquant"

# Image format libs
brew "mozjpeg"
brew "dcraw"

# Audio / Video

# convert / reencode video
brew "ffmpeg"
brew "mplayer"

# Codecs
brew "lame"
brew "x264"
brew "xvid"
brew "libvo-aacenc"
brew "libsndfile"

# Utilities
brew "htop"
brew "the_silver_searcher"
brew "thefuck"
brew "wget"
brew "hub" # A better github
brew "tree"
brew "unrar"
brew "siege"
brew "watchman"
brew "bash-completion"

# https://github.com/mas-cli/mas
brew "mas" # Automatically downloads things from the Apple Store

# cask "mactex" # mactex is huge

#### Cask Applications
cask "alfred"
cask "google-chrome"
cask "iterm2"
cask "nvalt"
cask "slack"
cask "flux"
cask "vlc"

# Code Editors
cask "sublime-text"
cask "visual-studio-code"

# More archives
cask "the-unarchiver"

# PDF Reader
cask "skim"

# Quick look extensions
cask "betterzipql"
cask "qlcolorcode"
cask "qlimagesize"
cask "qlmarkdown"
cask "qlprettypatch"
cask "qlstephen"
cask "quicklook-csv"
cask "quicklook-json"
cask "webpquicklook"

# Developer documentation
cask "dash"

# We need tunes
cask "spotify"

# Window Manager
cask "spectacle"

# Simple Launch Agent Control
cask "lunchy"

# Key Visualization for webcasting
# https://github.com/keycastr/keycastr
cask "keycastr"

## FONTS
# See https://github.com/caskroom/homebrew-fonts
# We might have to change the appdir here
cask "font-fira-code"
cask "font-fira-mono"
cask "font-input"
cask "font-monoid"
cask "font-monoisome"
cask "font-mononoki"
cask "font-roboto"
cask "font-roboto-mono"
cask "font-source-code-pro"

# Lastly, Mac App Store things
mas "1Password", id: 443987910
mas "Marked", id: 448925439
mas "1Password", id: 443987910
mas "Gemini", id: 463541543
mas "Disk Expert", id: 488920185
mas "Textual", id: 896450579

