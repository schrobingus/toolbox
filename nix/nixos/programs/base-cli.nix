{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    btop
    git vim wget
    fastfetch ncdu
    brightnessctl
    # nixos-rebuild-ng
  ];
}
