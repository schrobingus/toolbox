{ pkgs, ... }:

{
  services.displayManager = {
    defaultSession = "none+sway";
    ly.enable = true;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  environment.systemPackages = with pkgs; [
    mako wl-clipboard swaylock bemenu autotiling
  ];
}
