{ pkgs, ... }:

{
  # TODO: make an extended packages file
  environment.systemPackages = with pkgs; [
    librewolf ungoogled-chromium
    mpv
    sioyek
    xfce.thunar
    # TODO: get the fontviewer package on nixpkgs
    gnome-font-viewer
    pavucontrol
    lxappearance

    glib gsettings-desktop-schemas
    mesa mesa-gl-headers libglvnd
    mesa-demos
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
}
