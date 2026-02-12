{ pkgs, ... }:

{
  # macOS-specific packages
  home.packages = with pkgs; [
    # macOS utilities
    switchaudio-osx
    betterdisplay
    sshfs

    # Terminal
    kitty

    # Media
    ffmpeg
  ];

  # macOS-specific configs
  xdg.configFile = {
    "ghostty".source = ../../../ghostty;
  };
}
