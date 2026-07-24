{ pkgs, self, ... }:

{
  environment.systemPackages = with pkgs; [
    (import ./emacs.nix { inherit lib pkgs; })

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
  ];

  programs.zsh.enable = true;

  nix.enable = false; # Let the Nix install sort things out.
  
  system.stateVersion = 4;

  # TODO: change to pass from flake
  system.primaryUser = "brent";

  nixpkgs.hostPlatform = "aarch64-darwin";
}
