{ homeDirectory, toolboxDirectory, ... }:

{
  hjem = {
    users = {
      brent = {
        user = "brent";
        directory = homeDirectory;
        xdg.config.files = {
          "Code/User/settings.json".source     = "${toolboxDirectory}/togohome/.config/Code/User/settings.json";
          "VSCodium/User/settings.json".source = "${toolboxDirectory}/togohome/.config/Code/User/settings.json";

          "i3/config".source   = "${toolboxDirectory}/togohome/.config/i3/config";
          "sway/config".source = "${toolboxDirectory}/togohome/.config/sway/config";
          "scroll/config".source = "${toolboxDirectory}/togohome/.config/scroll/config";

          "dunst".source         = "${toolboxDirectory}/togohome/.config/dunst";
          "foot".source          = "${toolboxDirectory}/togohome/.config/foot";
          "ghostty".source       = "${toolboxDirectory}/togohome/.config/ghostty";
          "i3status".source      = "${toolboxDirectory}/togohome/.config/i3status";
          "picom.conf".source    = "${toolboxDirectory}/togohome/.config/picom.conf";
          "wallpaper.jpg".source = "${toolboxDirectory}/togohome/.config/wallpaper.jpg";
          "wmstatus.sh".source   = "${toolboxDirectory}/togohome/.config/wmstatus.sh";
        };
        files = {
          ".doom.d/config.el".source   = "${toolboxDirectory}/togohome/.doom.d/config.el";
          ".doom.d/init.el".source     = "${toolboxDirectory}/togohome/.doom.d/init.el";
          ".doom.d/packages.el".source = "${toolboxDirectory}/togohome/.doom.d/packages.el";

          ".vimrc".source      = "${toolboxDirectory}/togohome/.vimrc";
          ".ideavimrc".source  = "${toolboxDirectory}/togohome/.ideavimrc";
          ".Xresources".source = "${toolboxDirectory}/togohome/.Xresources";
          ".zshrc".source      = "${toolboxDirectory}/togohome/.zshrc";
        };
      };
    };
  };
}
