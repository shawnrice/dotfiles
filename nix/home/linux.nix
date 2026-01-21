{ pkgs, ... }:

{
  # Linux-specific packages
  home.packages = with pkgs; [
    # Clipboard (for Wayland)
    wl-clipboard

    # Add Linux-specific tools here
  ];

  # Linux-specific config
  # Note: On Arch, system-level stuff (Hyprland, drivers, etc.) stays in pacman
}
