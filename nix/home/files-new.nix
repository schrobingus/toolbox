
{ config, lib, dotfilesDir, ... }:

# TODO: this shit sucks. reduce to in store or post-activation.

let
  useStore = true;
  link = src:
    if useStore
    then src
    else config.lib.file.mkOutOfStoreSymlink src;
in {
  home.file = {
    
    # XDG Config Directories
    ".config/Code".source     = link "${dotfilesDir}/togohome/.config/Code";
    ".config/VSCodium".source = link "${dotfilesDir}/togohome/.config/Code";
    ".config/dunst".source    = link "${dotfilesDir}/togohome/.config/dunst";
    ".config/ghostty".source  = link "${dotfilesDir}/togohome/.config/ghostty";
    ".config/i3".source       = link "${dotfilesDir}/togohome/.config/i3";
    ".config/i3status".source = link "${dotfilesDir}/togohome/.config/i3status";
    ".config/wezterm".source  = link "${dotfilesDir}/togohome/.config/wezterm";
    ".config/zsh".source      = link "${dotfilesDir}/togohome/.config/zsh";

    # XDG Config Extra Files
    ".config/picom.conf".source    = link "${dotfilesDir}/togohome/.config/picom.conf";
    ".config/wallpaper.jpg".source = link "${dotfilesDir}/togohome/.config/wallpaper.jpg";

    # Home (user) Config Extra Files
    ".vimrc".source      = link "${dotfilesDir}/togohome/.vimrc";
    ".ideavimrc".source  = link "${dotfilesDir}/togohome/.ideavimrc";
    ".Xresources".source = link "${dotfilesDir}/togohome/.Xresources";
    
  };
}

