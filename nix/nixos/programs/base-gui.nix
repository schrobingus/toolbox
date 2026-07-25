{ pkgs, ... }:

{
  # NOTE: when you start porting to sway, you may want to split this into two files (xorg, wayland)
  # TODO: reorganize this whole thing
  environment.systemPackages = with pkgs; [
    librewolf
    ghostty emacs-pgtk # rxvt-unicode
    nautilus
    vicinae
    vscodium
    vesktop
    /*mpv*/ celluloid amberol # TODO: narrow
    papers
    localsend
    libreoffice
    gnome-font-viewer pavucontrol
    # feh xsel lxappearance scrot
    # xorg.xrandr xorg.xgamma
    # maim xclip

    # in loving memory of sou eduroam
    openconnect gp-saml-gui
    # globalprotect-openconnect

    adw-gtk3
    morewaita-icon-theme papirus-icon-theme

    glib gsettings-desktop-schemas
    mesa mesa-gl-headers libglvnd
    mesa-demos
  ];

  # required for globalprotect slop
  # nixpkgs.config.permittedInsecurePackages = [
  #   "qtwebengine-5.15.19"
  # ];

  programs.dconf.enable = true;
}
