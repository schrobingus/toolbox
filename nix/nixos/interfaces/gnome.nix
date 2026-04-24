{ pkgs, ... }:

{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;

  environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs ];
  environment.systemPackages = (with pkgs; [
    gnome-console gnome-tweaks
  ]) ++ (with pkgs.gnomeExtensions; [
    paperwm
    vertical-workspaces # This is V-Shell.
    vicinae
    caffeine
  ]);
}
