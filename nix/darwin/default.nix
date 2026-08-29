{ ... }:

{
  nix.enable = false; # Let the Nix install sort things out.

  system.stateVersion = 4;

  system.primaryUser = "brent";

  nixpkgs.hostPlatform = "aarch64-darwin";
}
