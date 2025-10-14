
# This version of the `files.nix` script, dubbed `files-store.nix`:
# - uses relative paths, and
# - copies directly to the store.

# This means that unlike the original script, this will be putting the dotfiles
# in the store, rather than symlinking directly. This is meant specifically for
# remote deployments, where the target doesn't have access to the host's instance
# of the flake. However, this also means that the flake will have to be rebuilt to
# enact changes made to the dotfiles.

# TODO: honestly consider just doing it manually
# TODO: annex this into the standard `files.nix` as a boolean toggle

{ config, lib, ... }:

let

  dotfilesDirRel = ../..;

  topLevel = builtins.attrNames (builtins.readDir "${dotfilesDirRel}/togohome");
  configLevel = builtins.attrNames (builtins.readDir "${dotfilesDirRel}/togohome/.config");

  mkLinks = paths:
    lib.attrsets.mergeAttrsList (map (relPath: {
      "${relPath}".source = "${dotfilesDirRel}/togohome/${relPath}";
    }) paths);

  homeFiles = builtins.filter (name: name != ".config") topLevel;
  configFiles = map (name: ".config/${name}") configLevel;

in {
  home.file = mkLinks (homeFiles ++ configFiles);
}
