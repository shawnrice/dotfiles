{ pkgs, ... }:

{
  # Linux-specific packages
  home.packages = with pkgs; [
    # Clipboard (for Wayland)
    wl-clipboard

    # SSH filesystem
    sshfs
  ];

  # Linux-specific config
  # Note: On Arch, system-level stuff (Hyprland, drivers, etc.) stays in pacman
}
