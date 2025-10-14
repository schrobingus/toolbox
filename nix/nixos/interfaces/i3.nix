{ pkgs, ... }:

{
  services = {
    displayManager = {
      defaultSession = "none+i3";
      ly.enable = true;
    };
    xserver = {
      enable = true;
      displayManager.startx.enable = true;
      desktopManager.xterm.enable = false;
      windowManager.i3.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    picom dunst i3lock i3status dmenu # autotiling
  ];

  environment.etc."X11/xinit/xinitrc".text = ''
    exec i3
  '';
}
