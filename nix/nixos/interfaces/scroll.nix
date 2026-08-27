{ inputs, pkgs, ... }:

{
  # services.displayManager.ly.enable = true;
  programs.scroll = {
    enable = true;
    package = inputs.scroll.packages.${pkgs.stdenv.hostPlatform.system}.scroll-git;
    wrapperFeatures.gtk = true;
  };

  environment.systemPackages = with pkgs; [
    wbg mako wl-clipboard swaylock bemenu autotiling
    playerctl grim slurp wl-clipboard
  ];
}
