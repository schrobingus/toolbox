
{ lib, pkgs, username, homeDir, dotfilesDir, ... }:

{
  home.username = username;
  home.homeDirectory = lib.mkForce homeDir;
  home.sessionVariables.DOTDIR = dotfilesDir; # TODO: check if this is problematic with the `self` change.

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    stow
    pfetch
    btop gh speedtest-cli
    devenv nurl
    bat fd pandoc ripgrep shellcheck tree zoxide fzf
    uv # gdal # Install ty from `uv tool`.
    # nixos-rebuild-ng colmena

    # TeX Packages
    texliveFull
    ghostscript

    # Haskell Packages
    haskell.compiler.ghc9102
    stack cabal-install zlib

    # TODO: move some of these packages over another nix import
  ] ++ (
    if pkgs.stdenv.isLinux then [
      # Linux Packages
      dconf2nix
      adw-gtk3 adwaita-icon-theme morewaita-icon-theme
      papirus-icon-theme qogir-icon-theme
      libnotify
    ] else [
      # macOS Packages
      macmon
    ]);

  # TODO: consider this: https://github.com/NixOS/nix/issues/4653
  # nix.package = pkgs.nix;
  # nix.settings = {
  #   experimental-features = [ "nix-command" "flakes" ];
  #   max-jobs = 4;
  #   cores = 4;
  # };
}

