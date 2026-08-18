{ lib, pkgs, pkgs-stable, ... }:

{
  # NOTE: when you start porting to sway, you may want to split this into two files (xorg, wayland)
  # TODO: reorganize this whole thing
  environment.systemPackages = with pkgs; [
    (import ../../emacs.nix { inherit lib pkgs pkgs-stable; })

    firefox
    ghostty foot rxvt-unicode
    nautilus thunar
    vicinae
    vscodium
    vesktop
    transmission_4-gtk
    mpv celluloid amberol
    papers sioyek
    localsend
    libreoffice
    gnome-font-viewer pavucontrol lxappearance
    feh xsel lxappearance scrot
    xrandr xgamma
    maim xclip

    # in loving memory of sou eduroam
    # NEVERMIND LMAO L BOZO LONG LIVE OSU EDUROAM
    # openconnect gp-saml-gui
    # globalprotect-openconnect

    adw-gtk3
    morewaita-icon-theme papirus-icon-theme

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
