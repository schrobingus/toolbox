{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    btop
    # neofetch FIXME: what the fuck why does neofetch require ueberzug?!?!?
    git vim wget
    nixos-rebuild-ng
  ];
}
