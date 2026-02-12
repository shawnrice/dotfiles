{ pkgs, ... }:

{
  imports = [
    ../../profiles/home-manager/base.nix
    ../../profiles/home-manager/dev.nix
    ../../profiles/home-manager/linux.nix
    ../../profiles/home-manager/hyprland.nix
  ];

  # Arch Linux manages system, we just manage user configs
  home.username = "shawn";
  home.homeDirectory = "/home/shawn";
  home.stateVersion = "24.05";

  # Spaceman-specific packages
  home.packages = with pkgs; [
    # Add machine-specific packages here
  ];
}
