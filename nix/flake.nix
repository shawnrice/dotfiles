{
  description = "Shawn's cross-platform dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # macOS system configuration
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }:
    let
      # Helper to make home-manager config for a given system
      mkHome = { system, username, homeDirectory, extraModules ? [] }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./home/common.nix
            {
              home = {
                inherit username homeDirectory;
                stateVersion = "24.05";
              };
            }
          ] ++ extraModules;
        };
    in
    {
      # Home Manager configurations
      homeConfigurations = {
        # Arch Linux
        "shawn@arch" = mkHome {
          system = "x86_64-linux";
          username = "shawn";
          homeDirectory = "/home/shawn";
          extraModules = [ ./home/linux.nix ];
        };

        # macOS (Apple Silicon)
        "shawn@work-mac" = mkHome {
          system = "aarch64-darwin";
          username = "shawn";
          homeDirectory = "/Users/shawn";
          extraModules = [ ./home/darwin.nix ];
        };

        # macOS (Intel) - adjust hostname as needed
        "shawn@personal-mac" = mkHome {
          system = "x86_64-darwin";
          username = "shawn";
          homeDirectory = "/Users/shawn";
          extraModules = [ ./home/darwin.nix ];
        };
      };

      # Optional: nix-darwin system configurations for macOS
      # darwinConfigurations = { ... };
    };
}
