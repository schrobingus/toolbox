{ pkgs, ... }:

{
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    firefox ghostty thunar vicinae
    vscodium vesktop
    mpv transmission_4-gtk
    sioyek libreoffice
    localsend
    gnome-font-viewer pavucontrol
    lxappearance

    adw-gtk3 papirus-icon-theme

    glib gsettings-desktop-schemas
    mesa mesa-gl-headers libglvnd
    mesa-demos

    brightnessctl
  ];

  programs.dconf.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; pkgs.lib.mkForce [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };

  programs.nix-ld.enable = true;
}
