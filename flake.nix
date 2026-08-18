{
  description = "Personal Nix Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lem = {
      url = "github:lem-project/lem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-fonts = {
      url = "github:Lyndeno/apple-fonts.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    scroll = {
      url = "github:Diax170/scroll-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nix-darwin, hjem, ... } @ inputs: let
    lib = nixpkgs.lib;

    mkSystem = { system, builder, baseModule, extraModules ? [], specialArgs ? {} }:
      builder {
        inherit system;

        specialArgs = {
          inherit self inputs;

          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
        } // specialArgs;

        modules = [ baseModule ] ++ extraModules;
      };

    nixosTargets = {
      thonk = {
        system = "x86_64-linux";
        extraModules = [
          hjem.nixosModules.default

          {
            networking.hostName = "thonk";
          }

          ./nix/nixos/bootloaders/grub-efi.nix
          ./nix/nixos/hardware-configuration/x131e-chromebook.nix
          ./nix/nixos/interfaces/sway.nix
          ./nix/nixos/programs/base-gui.nix
          ./nix/nixos/programs/base-cli.nix
          ./nix/nixos/programs/clankers.nix
          ./nix/nixos/programs/devutils.nix
          ./nix/nixos/services/avahi.nix
          ./nix/fonts.nix
          ./nix/hjem.nix
        ];
      };

      thonktuah = {
        system = "x86_64-linux";
        extraModules = [
          hjem.nixosModules.default

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
          ./nix/fonts.nix
          ./nix/hjem.nix
        ];
      };
    };

    darwinTargets = {
      geogaddi = {
        system = "aarch64-darwin";
        extraModules = [
          hjem.darwinModules.default

          # ./nix/darwin/homebrew.nix
          ./nix/darwin/settings.nix
          ./nix/fonts.nix
          ./nix/hjem.nix
        ];
      };
    };

  in {
    nixosConfigurations = lib.mapAttrs (_: cfg: mkSystem {
      inherit (cfg) system;
      builder = nixpkgs.lib.nixosSystem;
      baseModule = ./nix/nixos/default.nix;
      extraModules = cfg.extraModules or [];
      specialArgs = {
        homeDirectory    = "/home/brent";
        toolboxDirectory = "/home/brent/Sources/toolbox";
      };
    }) nixosTargets;

    darwinConfigurations = lib.mapAttrs (_: cfg: mkSystem {
      inherit (cfg) system;
      builder = nix-darwin.lib.darwinSystem;
      baseModule = ./nix/darwin/default.nix;
      extraModules = cfg.extraModules or [];
      specialArgs = {
        homeDirectory    = "/Users/brent";
        toolboxDirectory = "/Users/brent/Sources/toolbox";
      };
    }) darwinTargets;
  };
}
