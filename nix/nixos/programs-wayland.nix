{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    foot wbg mako wl-clipboard swaylock bemenu
    playerctl grim slurp autotiling
  ];
}
