# Detect OS - direct assignment, no function overhead
case "$OSTYPE" in
  darwin*) IS_MACOS=true  IS_LINUX=false ;;
  linux*)  IS_MACOS=false IS_LINUX=true ;;
  *)       IS_MACOS=false IS_LINUX=false ;;
esac
