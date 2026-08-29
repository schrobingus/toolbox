{ ... }:

{
  imports = [ ../programs-wayland.nix ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
}
