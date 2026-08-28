{ inputs, pkgs, pkgs-stable, self, toolboxDirectory, ... }:

{
  environment.systemPackages = with pkgs; [
    (import ../emacs.nix { inherit lib pkgs pkgs-stable; })

    lem-webview lem-ncurses
    (writeShellApplication {
      name = "lem-webview";
      text = "${lem-webview}/bin/lem \"$@\"";
    })
    (writeShellApplication {
      name = "lem-ncurses";
      text = "${lem-ncurses}/bin/lem \"$@\"";
    })

    nix-output-monitor
    uv ty jupyter marimo
    rustc cargo clippy rust-analyzer
    ghc stack cabal-install haskell-language-server
    gfortran fortran-language-server
    go gopls
    luajit luarocks
    nodejs
    xcodes utm qemu
    fastfetch pfetch
    ripgrep vim wget
    zstd p7zip
    texliveFull typst
    pandoc marp-cli
    exercism
    yt-dlp
    cmake pkg-config meson ninja
    zsh-history-substring-search
    opencode pi-coding-agent
  ];

  nixpkgs.overlays = [ inputs.lem.overlays.default ];

  environment.variables = {
    TOOLBOX_DIRECTORY = toolboxDirectory;
    ZSH_HSS =
      "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh";
  };

  programs.zsh.enable = true;

  nix.enable = false; # Let the Nix install sort things out.

  system.stateVersion = 4;

  # TODO: change to pass from flake
  system.primaryUser = "brent";

  nixpkgs.hostPlatform = "aarch64-darwin";
}
