{
  description = "Shawn's cross-platform dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ai-tools = {
      url = "github:numtide/nix-ai-tools";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, darwin, ... }:
    let
      overlays = {};

      # Load nix-darwin with home-manager integrated
      loadDarwin = import ./load-darwin.nix { inherit self inputs overlays; };

      # Helper to make standalone home-manager config (for Linux)
      mkHome = { system, machine }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ machine ];
          extraSpecialArgs = {
            inherit inputs;
          };
        };
    in
    {
      # nix-darwin system configurations (macOS only)
      darwinConfigurations = {
        # Current machine (Apple Silicon)
        "Shawns-Ashby-MacBook" = loadDarwin {
          system = "aarch64-darwin";
          machine = ./machines/shawns-ashby-macbook;
        };

        # Generic template for new Macs
        generic-darwin = loadDarwin {
          system = "aarch64-darwin";
          machine = ./machines/generic-darwin;
        };
      };

      # Home Manager configurations (standalone for Linux)
      homeConfigurations = {
        # Arch Linux with Hyprland
        "shawn@spaceman" = mkHome {
          system = "x86_64-linux";
          machine = ./machines/spaceman;
        };

        # Generic Linux template
        "shawn@generic-linux" = mkHome {
          system = "x86_64-linux";
          machine = ./machines/generic-linux;
        };
      };
    };
}
