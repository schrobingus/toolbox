{ lib, self, homeDirectory, toolboxDirectory, copyToGoHome, ... }:

let
  deployToGoHome = lib.mapAttrs (_: value: value // {
    type = if copyToGoHome then "copy" else "symlink";
  });
  src = file:
    if copyToGoHome
    then builtins.path { path = "${self}/togohome/${file}"; }
    else "${toolboxDirectory}/togohome/${file}";
in {
  hjem = {
    users = {
      brent = {
        user = "brent";
        directory = homeDirectory;
        xdg.config.files = deployToGoHome {
          "Code/User/settings.json".source     = src ".config/Code/User/settings.json";
          "VSCodium/User/settings.json".source = src ".config/Code/User/settings.json";

          "i3/config".source     = src ".config/i3/config";
          "sway/config".source   = src ".config/sway/config";
          "scroll/config".source = src ".config/scroll/config";

          "dunst/dunstrc".source   = src ".config/dunst/dunstrc";
          "foot/foot.ini".source   = src ".config/foot/foot.ini";
          "ghostty/config".source  = src ".config/ghostty/config";
          "i3status/config".source = src ".config/i3status/config";
          "picom.conf".source      = src ".config/picom.conf";
          "wallpaper.jpg".source   = src ".config/wallpaper.jpg";
          "wmstatus.sh".source     = src ".config/wmstatus.sh";

          "ghostty/themes/flexoki-dark-bingus".source  = src ".config/ghostty/themes/flexoki-dark-bingus";
          "ghostty/themes/flexoki-light-bingus".source = src ".config/ghostty/themes/flexoki-light-bingus";
        };
        files = deployToGoHome {
          ".doom.d/config.el".source   = src ".doom.d/config.el";
          ".doom.d/init.el".source     = src ".doom.d/init.el";
          ".doom.d/packages.el".source = src ".doom.d/packages.el";

          ".vimrc".source      = src ".vimrc";
          ".ideavimrc".source  = src ".ideavimrc";
          ".Xresources".source = src ".Xresources";
          ".zshrc".source      = src ".zshrc";
        };
      };
    };
  };
}
