{ inputs, pkgs, ... }:

{
  imports = [ ../programs-wayland.nix ];

  programs.scroll = {
    enable = true;
    package = inputs.scroll.packages.${pkgs.stdenv.hostPlatform.system}.scroll-git;
    wrapperFeatures.gtk = true;
  };
}
