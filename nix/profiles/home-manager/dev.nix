{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Git tools
    git
    gh
    lazygit
    git-standup
    git-absorb
    git-filter-repo
    delta
    difftastic
    tig

    # Development tools
    direnv
    nix-direnv
    dix
    watchman
    cmake

    # Programming languages & toolchains
    bun
    fnm
    go
    rustup
    zig
    mise
    shfmt
    stylua

    # Docker & containers
    lazydocker

    # Code search & analysis
    ast-grep
    cloc
    superfile

    # Databases
    postgresql

    # Graphics libraries (for development)
    cairo
    giflib
    glib
    harfbuzz
    libjpeg
    libpng
    librsvg
    pango
    pixman
    pkg-config
    fontconfig
    freetype
    # gdk-pixbuf - conflicts with librsvg, only needed in PKG_CONFIG_PATH

    # Additional dev tools
    mergiraf
    tabby
    vim

    # AI/LLM tools
    (python3.withPackages (
      ps: with ps; [
        llm
        llm-anthropic
        llm-gemini
        llm-ollama
      ]
    ))
  ];

  # Git configuration (platform-specific parts in .gitconfig files)
  programs.git = {
    enable = true;
    settings = {
      user.name = "Shawn Rice";
      # user.email set in machine-specific config or .gitconfig
      init.defaultBranch = "main";
    };
  };

  programs.lazygit.enable = true;
}
