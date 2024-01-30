# Function to detect the operating system
function detect_os() {
  case "$(uname -s)" in
  Darwin*)
    IS_MACOS=true
    IS_LINUX=false
    IS_WSL=false
    return
    ;;
  Linux*)
    IS_LINUX=true
    IS_MACOS=false
    if grep -qE "(Microsoft|WSL)" /proc/version &>/dev/null; then
      IS_WSL=true
    else
      IS_WSL=false
    fi
    return
    ;;
  *)
    IS_MACOS=false
    IS_LINUX=false
    IS_WSL=false
    ;;
  esac
}

detect_os
unset detect_os
