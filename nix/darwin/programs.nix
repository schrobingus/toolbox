{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xcodes utm
  ];
}