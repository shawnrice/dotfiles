{
  pkgs,
  system,
  lib,
  ...
}@args:
{
  nixpkgs.config.allowUnfree = true;

  nix.enable = true;
  nix.package = pkgs.nix;
  nix.settings.experimental-features = lib.mkDefault "nix-command flakes";

  # System fonts
  fonts.packages = with pkgs; [
    fira-code
    nerd-fonts.fira-code
    geist-font
    hasklig
    inconsolata
    iosevka
    meslo-lg
    monaspace
    mononoki
    source-code-pro
    victor-mono
    nerd-fonts.symbols-only
  ];

  # Enable zsh system-wide (configs managed by home-manager)
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    enableSyntaxHighlighting = false;
  };

  # macOS system defaults
  system.stateVersion = 4;
  system.defaults.NSGlobalDomain.NSWindowShouldDragOnGesture = true;

  # Default primary user (override in machine config if needed)
  system.primaryUser = "shawn";

  # Graphics libraries PKG_CONFIG_PATH for development
  environment.variables.PKG_CONFIG_PATH = builtins.concatStringsSep ":" (
    map (p: "${p}/lib/pkgconfig") [
      pkgs.pixman
      pkgs.cairo.dev
      pkgs.libpng.dev
      pkgs.pango.dev
      pkgs.glib.dev
      pkgs.fontconfig.dev
      pkgs.freetype.dev
      pkgs.gdk-pixbuf
      pkgs.harfbuzz.dev
    ]
  );
}
