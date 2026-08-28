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

  outputs = { self, nixpkgs, nixpkgs-stable, nix-darwin, hjem, scroll, ... } @ inputs: let
    lib = nixpkgs.lib;

    mkSystem = { target, builder, baseModule, specialArgs ? {} }:
      let
        inherit (target) system;
        extraModules = target.extraModules or [];
        copyToGoHome = target.copyToGoHome or false;
      in builder {
        inherit system;

        specialArgs = {
          inherit self inputs copyToGoHome;

          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
        } // specialArgs;

        modules = [ baseModule ] ++ extraModules;
      };

    nixosTargets = {
      boxed = {
        system = "aarch64-linux";
        copyToGoHome = true;
        extraModules = [
          hjem.nixosModules.default
          scroll.nixosModules.default
          {
            networking.hostName = "boxed";
          }

          ./nix/nixos/bootloaders/systemd-boot-efi.nix
          ./nix/nixos/hardware-configuration/boxed-utm.nix
          ./nix/nixos/programs/base-gui.nix
          ./nix/nixos/programs/base-cli.nix
          ./nix/nixos/programs/devutils.nix
          ./nix/nixos/services/avahi.nix
          ./nix/fonts.nix
          ./nix/hjem.nix

          ./nix/nixos/interfaces/scroll.nix
          ./nix/nixos/interfaces/sway.nix
          ./nix/nixos/interfaces/i3.nix
        ];
      };

      thonk = {
        system = "x86_64-linux";
        extraModules = [
          hjem.nixosModules.default
          scroll.nixosModules.default

          {
            networking.hostName = "thonk";
          }

          ./nix/nixos/hardware-configuration/x131e-chromebook.nix
          ./nix/nixos/bootloaders/grub-efi.nix
          ./nix/nixos/programs/base-gui.nix
          ./nix/nixos/programs/base-cli.nix
          ./nix/nixos/programs/clankers.nix
          ./nix/nixos/programs/devutils.nix
          ./nix/nixos/services/avahi.nix
          ./nix/fonts.nix
          ./nix/hjem.nix

          ./nix/nixos/interfaces/scroll.nix
          ./nix/nixos/interfaces/sway.nix
          ./nix/nixos/interfaces/i3.nix
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

          ./nix/nixos/hardware-configuration/e14-gen2.nix
          ./nix/nixos/bootloaders/grub-efi.nix
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
      target = cfg;
      builder = nixpkgs.lib.nixosSystem;
      baseModule = ./nix/nixos/default.nix;
      specialArgs = {
        homeDirectory    = "/home/brent";
        toolboxDirectory = "/home/brent/Sources/toolbox";
      };
    }) nixosTargets;

    darwinConfigurations = lib.mapAttrs (_: cfg: mkSystem {
      target = cfg;
      builder = nix-darwin.lib.darwinSystem;
      baseModule = ./nix/darwin/default.nix;
      specialArgs = {
        homeDirectory    = "/Users/brent";
        toolboxDirectory = "/Users/brent/Sources/toolbox";
      };
    }) darwinTargets;
  };
}
