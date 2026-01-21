{ pkgs, ... }:

{
  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Packages installed for all machines
  home.packages = with pkgs; [
    # Core CLI tools
    bat
    btop
    eza
    fd
    fzf
    jq
    ripgrep
    zoxide

    # Git
    git
    gh
    lazygit

    # Development
    # nodejs  # Consider using fnm instead for version management
    # rustup  # Or manage via rustup directly

    # Editors
    neovim

    # Terminal
    starship
    zellij
  ];

  # Symlink config files (keeps configs in their native format)
  xdg.configFile = {
    # Neovim config
    "nvim".source = ../../nvim;

    # Add more as needed:
    # "wezterm/wezterm.lua".source = ../../wezterm.lua;
    # "lazygit/config.yml".source = ../../lazygit/config.yml;
    # "starship.toml".source = ../../starship.toml;
  };

  # Shell - we're managing zsh ourselves, just ensure it's available
  # programs.zsh.enable = true;

  # Git config (optional - or keep using your .gitconfig)
  # programs.git = {
  #   enable = true;
  #   userName = "Shawn Rice";
  #   userEmail = "...";
  # };
}
