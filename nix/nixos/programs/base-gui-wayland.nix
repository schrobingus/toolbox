{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    foot
    imv slurp grim
    wl-clipboard
    emacs-pgtk
  ];
}
