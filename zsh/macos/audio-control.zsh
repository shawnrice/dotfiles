local HAS_SWITCH_AUDIO_SOURCE=$(command -v SwitchAudioSource >/dev/null 2>&1)
local HAS_JQ=$(command -v jq >/dev/null 2>&1)

# Exit early if the CLI tool is not available
if ! HAS_SWITCH_AUDIO_SOURCE; then
  echo '[WARN] SwitchAudioSource not found. Not registering wrapper functions.'
  echo '       run `brew install switchaudio-osx` and reload the shell.'
  echo '       see https://github.com/deweller/switchaudio-osx for more info'
  return
fi

# switchaudio-osx

function get_current_audio_output() {
  SwitchAudioSource -c -f cli
}

function get_current_audio_input() {
  SwitchAudioSource -c -t input
}

function get_audio_output_options() {
  SwitchAudioSource -a
}

function get_audio_input_options() {
  SwitchAudioSource -a -t input
}

function set_audio_input_by_id() {
  local id=$1
  SwitchAudioSource
}

# function set_audio_output() {
#   local device=$1
# }

# function set_audio_input() {

# }

function mute_microphone() {
  SwitchAudioSource -m mute -t input
}

function toggle_microphone() {
  SwitchAudioSource -m toggle -t input
}

function mute_speaker() {
  SwitchAudioSource -m mute -t output
}

function toggle_speaker() {
  SwitchAudioSource -m toggle -t output
}
