
# This `files.nix` script will:
# - symlink the dotfiles directly from the flake instance, and
# - use absolute paths to link.

# This is the script that is intended to be used on machines, where the 
# flake is locally deployed (aka most intances). With this script, changes can be
# made to the dotfiles without having to rebuild the flake.

# If you are deploying remotely, it is optimal to use `files-store.nix` instead.

# TODO: honestly consider just doing it manually

{ config, lib, dotfilesDir, ... }:

let

  topLevel = builtins.attrNames (builtins.readDir "${dotfilesDir}/togohome");
  configLevel = builtins.attrNames (builtins.readDir "${dotfilesDir}/togohome/.config");

  mkLinks = paths:
    lib.attrsets.mergeAttrsList (map (relPath: {
      "${relPath}".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/togohome/${relPath}";
    }) paths);

  homeFiles = builtins.filter (name: name != ".config") topLevel;
  configFiles = map (name: ".config/${name}") configLevel;

in {
  home.file = mkLinks (homeFiles ++ configFiles);
}

