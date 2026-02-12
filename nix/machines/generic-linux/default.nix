{ pkgs, ... }:

{
  imports = [
    ../../profiles/home-manager/base.nix
    ../../profiles/home-manager/dev.nix
    ../../profiles/home-manager/linux.nix
  ];

  home.username = "shawn";
  home.homeDirectory = "/home/shawn";
  home.stateVersion = "25.11";
}
