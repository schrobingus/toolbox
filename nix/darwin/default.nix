{ pkgs, pkgs-stable, self, toolboxDirectory, ... }:

{
  environment.systemPackages = with pkgs; [
    (import ../emacs.nix { inherit lib pkgs pkgs-stable; })

    nix-output-monitor
    uv ty jupyter marimo
    rustc cargo clippy rust-analyzer
    ghc stack cabal-install haskell-language-server
    go gopls
    luajit luarocks
    nodejs
    xcodes utm qemu
    fastfetch pfetch
    ripgrep vim wget
    zstd p7zip
    texliveFull typst
    pandoc marp-cli
    yt-dlp
    zsh-history-substring-search
  ];

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
