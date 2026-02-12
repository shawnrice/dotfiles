{ pkgs, ... }:

{
  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Core CLI tools - works on all platforms
  home.packages = with pkgs; [
    # Core utilities
    coreutils-full
    uutils-coreutils
    uutils-diffutils
    curl
    wget
    tree
    fastfetch

    # Terminal enhancements
    bat
    btop
    eza
    fzf
    zoxide
    starship
    glow
    gum
    navi

    # File management
    fd
    yazi

    # Text processing
    jq
    yq  # provides both yq and xq
    ripgrep
    silver-searcher
    gawk
    gnugrep
    gnused

    # Monitoring & logs
    lnav
    pastel
    chafa
  ];

  # Symlink dotfiles from repo
  xdg.configFile = {
    "nvim/zeta.nvim".source = ../../../nvim/zeta.nvim;
    # Uncomment as you add these config directories to your dotfiles
    # "bat".source = ../../../bat;
    # "btop".source = ../../../btop;
    # "lazygit".source = ../../../lazygit;
    # "zellij".source = ../../../zellij;
  };

  # Enable common programs
  programs.bat.enable = true;
  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
  };
  programs.ripgrep.enable = true;
  programs.starship.enable = true;
  programs.yazi.enable = true;

  # Default editor
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
