{
  description = "Personal Nix Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, ... }: let
    lib = nixpkgs.lib;

    mkSystem = { system, builder, baseModule, extraModules ? [] }:
      builder {
        inherit system;
        specialArgs = { inherit self; };
        modules = [ baseModule ] ++ extraModules;
      };

    nixosTargets = {
      thonktuah = {
        system = "x86_64-linux";
        extraModules = [
          { 
            networking.hostName = "thonktuah";
            services.xserver.xkb.options = "ctrl:swapcaps";
          }
          ./nix/nixos/bootloaders/grub-efi.nix
          ./nix/nixos/hardware-configuration/e14-gen2.nix
          ./nix/nixos/interfaces/gnome.nix
          ./nix/nixos/programs/base-gui.nix
          ./nix/nixos/programs/base-cli.nix
          ./nix/nixos/programs/devutils.nix
          ./nix/nixos/services/avahi.nix
          ./nix/nixos/fonts.nix
        ];
      };
    };

    darwinTargets = {
      geogaddi = {
        system = "aarch64-darwin";
        extraModules = [
          # ./nix/darwin/homebrew.nix
          ./nix/darwin/settings.nix
        ];
      };
    };

  in {
    nixosConfigurations = lib.mapAttrs (_: cfg: mkSystem {
      inherit (cfg) system;
      builder = nixpkgs.lib.nixosSystem;
      baseModule = ./nix/nixos/default.nix;
      extraModules = cfg.extraModules or [];
    }) nixosTargets;

    darwinConfigurations = lib.mapAttrs (_: cfg: mkSystem {
      inherit (cfg) system;
      builder = nix-darwin.lib.darwinSystem;
      baseModule = ./nix/darwin/default.nix;
      extraModules = cfg.extraModules or [];
    }) darwinTargets;
  };
}
