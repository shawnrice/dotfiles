{ pkgs, ... }:

{
  # Hyprland configs (Hyprland itself installed via pacman on Arch)
  # This profile just manages the dotfiles

  xdg.configFile = {
    # Add your Hyprland config when ready
    # "hypr".source = ../../../hyprland;
  };

  # Graphical apps that work on Linux
  home.packages = with pkgs; [
    # Add GUI apps here as needed
  ];
}
