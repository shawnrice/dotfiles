{
  config,
  pkgs,
  inputs,
  self,
  ...
}:
{
  imports = [
    ../../profiles/darwin/base.nix
  ];

  system.stateVersion = 4;
  system.configurationRevision = self.rev or self.dirtyRev or null;
  networking.hostName = "Shawns-Ashby-MacBook";

  # Machine-specific system packages (AI tools, etc.)
  nixpkgs.hostPlatform.system = "aarch64-darwin";

  # Import AI tools if available
  environment.systemPackages = let
    ai-tools = inputs.nix-ai-tools.packages.aarch64-darwin or {};
    optionalAiTools = builtins.filter (pkg: pkg != null) [
      (ai-tools.coderabbit-cli or null)
      (ai-tools.opencode or null)
      (ai-tools.claude-code or null)
      (ai-tools.openspec or null)
    ];
  in
    (with pkgs; [
      # AI CLI tools
      cursor-cli
    ]) ++ optionalAiTools;

  # Allow unfree packages
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "betterdisplay"
      "ngrok"
      "1password-cli"
      "_1password-cli"
      "claude-code"
      "coderabbit-cli"
      "cursor-cli"
    ];

  # Home Manager configuration for primary user
  home-manager.users.${config.system.primaryUser} = {
    imports = [
      ../../profiles/home-manager/base.nix
      ../../profiles/home-manager/dev.nix
      ../../profiles/home-manager/macos.nix
    ];

    home.stateVersion = "24.05";

    # Additional packages for this machine
    home.packages = with pkgs; [
      # Cloud & infrastructure
      cloudflared
      aws-vault
      kubectl
      kubernetes-helm
      ngrok

      # Terminal tools
      zellij
      _1password-cli

      # Utilities
      aerc
      tenv
    ];
  };
}
