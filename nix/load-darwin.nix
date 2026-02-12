{
  self,
  inputs,
  overlays ? {},
  ...
}:
{ machine, system }:
let
  inherit (inputs)
    darwin
    home-manager
    ;

  extraModule =
    { config, ... }:
    {
      config = {
        nixpkgs.config.allowUnfree = true;

        users.users.${config.system.primaryUser} = {
          name = config.system.primaryUser;
          home = "/Users/${config.system.primaryUser}";
        };

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit inputs;
            systemManager = "home-manager";
          };
        };
      };
    };
in
darwin.lib.darwinSystem {
  inherit system;
  modules = [
    machine
    home-manager.darwinModules.home-manager
    extraModule
  ];
  specialArgs = {
    inherit self inputs system;
    systemManager = "nix-darwin";
  };
}
