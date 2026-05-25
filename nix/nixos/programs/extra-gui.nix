{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vicinae
    ghostty
    vesktop
    transmission_4-gtk
  ];
}
