{ pkgs, ... }:

{
  # macOS-specific packages
  home.packages = with pkgs; [
    # macOS doesn't need wl-clipboard, has pbcopy/pbpaste

    # Add macOS-specific tools here
  ];

  # macOS-specific config
}
