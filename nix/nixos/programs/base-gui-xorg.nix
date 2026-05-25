{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rxvt-unicode
    feh imv xsel scrot
    xorg.xrandr xorg.xgamma
    maim xclip
    emacs
  ];
}
