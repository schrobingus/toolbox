{ pkgs, self, ... }:

{
  environment.systemPackages = with pkgs; [
    colmena deploy-rs morph 
    nix-output-monitor
    luajit luarocks
    # neofetch FIXME: what the fuck why does neofetch require ueberzug?!?!?
    ripgrep vim wget
    p7zip
  ];

  programs.zsh.enable = true;

  # TODO: this is commented because of determinate nix. make a conditional that adjusts as so
  /* nix = {
    enable = true;
    package = pkgs.nix;
    settings = {
      experimental-features = "nix-command flakes";
      max-jobs = 4;
      cores = 2;
    };
  }; */
  nix.enable = false;
  
  # FIXME: this is specifically because of peazip. do a pr to nixpkgs. check home/default.nix
  nixpkgs.config.allowUnsupportedSystem = true;

  ids.gids.nixbld = 350;

  system.configurationRevision = self.rev or self.dirtyRev or null;

  system.stateVersion = 4;

  # TODO: change to pass from flake
  system.primaryUser = "brent";

  nixpkgs.hostPlatform = "aarch64-darwin";
}
