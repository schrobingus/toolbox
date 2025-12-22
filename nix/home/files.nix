
# Do note that this will bind the files to the Nix store. This means that if you change
# a dotfile from here, the Home Manager generation (and by proxy, the flake) will need
# to be rebuilt for changes to take effect.

# Because of this reason, this module is disabled by default, but can be turned on per
# host. I use GNU Stow for managing my dotfiles without having to go through the store.

# See: https://jade.fyi/blog/use-nix-less/

# TODO: https://github.com/feel-co/hjem FUCK WHY DIDN'T GOOGLE TELL ME ABOUT THIS

{ config, lib, dotfilesDir, ... }:

{
  home.file = {
    
    # XDG Config Directories
    ".config/Code".source     = "${dotfilesDir}/togohome/.config/Code";
    ".config/VSCodium".source = "${dotfilesDir}/togohome/.config/Code";
    ".config/dunst".source    = "${dotfilesDir}/togohome/.config/dunst";
    ".config/ghostty".source  = "${dotfilesDir}/togohome/.config/ghostty";
    ".config/i3".source       = "${dotfilesDir}/togohome/.config/i3";
    ".config/i3status".source = "${dotfilesDir}/togohome/.config/i3status";
    ".config/wezterm".source  = "${dotfilesDir}/togohome/.config/wezterm";
    ".config/zsh".source      = "${dotfilesDir}/togohome/.config/zsh";

    # XDG Config Extra Files
    ".config/picom.conf".source    = "${dotfilesDir}/togohome/.config/picom.conf";
    ".config/wallpaper.jpg".source = "${dotfilesDir}/togohome/.config/wallpaper.jpg";

    # Home (user) Config Extra Files
    ".vimrc".source      = "${dotfilesDir}/togohome/.vimrc";
    ".ideavimrc".source  = "${dotfilesDir}/togohome/.ideavimrc";
    ".Xresources".source = "${dotfilesDir}/togohome/.Xresources";
    
  };
}

