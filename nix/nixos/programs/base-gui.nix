{ pkgs, ... }:

{
  # NOTE: when you start porting to sway, you may want to split this into two files (xorg, wayland)
  environment.systemPackages = with pkgs; [
    librewolf
    ghostty rxvt-unicode
    vesktop
    mpv celluloid amberol # TODO: narrow
    sioyek papers # TODO: narrow
    nautilus
    gnome-font-viewer pavucontrol
    feh xsel lxappearance scrot
    xorg.xrandr xorg.xgamma
    maim xclip

    # TODO: might want to move these into their own file, they're kinda important
    glib gsettings-desktop-schemas
    xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk
    mesa mesa-gl-headers libglvnd
    mesa-demos
  ];

  programs.dconf.enable = true;
}
