{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    geist-font
    nerd-fonts.geist-mono
    noto-fonts
    noto-fonts-lgc-plus
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji-blob-bin
    nerd-fonts.noto
    cantarell-fonts
    liberation_ttf
    symbola
    corefonts # proprietary microsoft fonts
  ];
}
