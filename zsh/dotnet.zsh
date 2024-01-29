if ! command_exists dotnet; then
  echo "[WARN]: dotnet is not installed. Skipping dotnet configuration."
  return 0
fi

# Do not send MS telemetry with dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT=1

export PATH="${PATH}:${HOME}/.dotnet/tools" # Add dotnet tools to the path
