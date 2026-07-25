{ lib, pkgs, inputs, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "symbola"
      "corefonts"
    ];

  fonts.packages = (with pkgs; [
    geist-font
    nerd-fonts.geist-mono

    noto-fonts
    noto-fonts-lgc-plus
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif

    cantarell-fonts
    liberation_ttf
    symbola
    corefonts
  ]) ++ (with inputs.apple-fonts.packages.
    ${pkgs.stdenv.hostPlatform.system}; [
      sf-mono
      sf-mono-nerd
      sf-pro
      sf-compact
      ny
    ])
  ++ (pkgs.lib.optional pkgs.stdenv.isLinux
    pkgs.noto-fonts-emoji-blob-bin); # emoji package for Linux
}
