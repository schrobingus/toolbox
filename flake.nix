
{
  description = "Personal Nix Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    leatherman.url = "github:schrobingus/leatherman";
    # leatherman.url = "path:/Users/brent/Sources/nvim-config";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-index-database, agenix, leatherman, ... } @ inputs: let

    lib = nixpkgs.lib;

    info = system: let
      username = "brent";
      homeDir =
        if builtins.match ".*-darwin" system != null
          then "/Users/${username}"
        else "/home/${username}";
      # dotfilesDir = "${homeDir}/Sources/dotfiles";
      dotfilesDir = self;
    in { inherit username homeDir dotfilesDir; };

    homeManagerConfig = { pkgs, system, extraHomeModules ? [], linkDotfilesFromStore ? false }: {
      home.packages = [
        pkgs.home-manager
        inputs.leatherman.packages.${system}.default
      ];
      imports = [
        ./nix/home/default.nix
      ] ++ lib.optionals linkDotfilesFromStore [
        ./nix/home/files.nix
      ] ++ extraHomeModules;
    };

    mkNixOSConfig = { system, extraHomeModules ? [], extraNixOSModules ? [], linkDotfilesFromStore ? false }: let
      pkgs = import nixpkgs { inherit system; };
    in nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = { inherit self; };
        modules = [
          ./nix/nixos/default.nix
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager {
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs; } // info system;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.brent = homeManagerConfig {
              inherit pkgs system extraHomeModules;
              linkDotfilesFromStore = linkDotfilesFromStore;
            };
          }
        ] ++ extraNixOSModules;
      };

    mkDarwinConfig = { system, extraHomeModules ? [], extraDarwinModules ? [], linkDotfilesFromStore ? false }: let
      pkgs = import nixpkgs { inherit system; };
    in nix-darwin.lib.darwinSystem {
        system = system;
        specialArgs = { inherit self; };
        modules = [
          ./nix/darwin/default.nix
        ] ++ extraDarwinModules ++ [
            home-manager.darwinModules.home-manager {
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = { inherit inputs; } // info system;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.brent = homeManagerConfig {
                inherit pkgs system extraHomeModules;
                linkDotfilesFromStore = linkDotfilesFromStore;
              };
            }
          ];
      };

    mkHomeConfig = { system, extraHomeModules ? [], linkDotfilesFromStore ? false }: let
      pkgs = import nixpkgs { inherit system; };
    in home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        extraSpecialArgs = { inherit self; } // info system;
        modules = [
          homeManagerConfig {
            inherit pkgs system extraHomeModules;
            linkDotfilesFromStore = linkDotfilesFromStore;
          }
        ];
      };

    commonHomeModules = [
      ./nix/home/git.nix
      ./nix/home/zsh.nix
      ./nix/home/nix-index-db.nix
    ];

    commonBaseCliModules = [
      ./nix/nixos/programs/base-cli.nix
      ./nix/nixos/programs/portable-cli.nix
    ];

    nixosTargets = {
      order = {
        system = "x86_64-linux";
        extraNixOSModules = [
          {
            networking.hostName = "order";
            system.stateVersion = "25.11";
            security.pam.sshAgentAuth.enable = true;
            security.sudo.wheelNeedsPassword = false;
          }
          ./nix/nixos/bootloaders/grub-efi.nix
          ./nix/nixos/hardware-configuration/order.nix
          ./nix/nixos/services/avahi.nix
          ./nix/nixos/services/bcache.nix
          ./nix/nixos/services/glances.nix
        ] ++ commonBaseCliModules;
        extraHomeModules = commonHomeModules;
      };

      flakyvm-qemu = {
        system = "aarch64-linux";
        extraNixOSModules = [
          {
            networking.hostName = "flakyvm-qemu";
          }
          ./nix/nixos/bootloaders/systemd-boot-efi.nix
          ./nix/nixos/hardware-configuration/qemu.nix
          ./nix/nixos/programs/base-cli.nix
          ./nix/nixos/programs/portable-cli.nix
          ./nix/nixos/services/avahi.nix
          ./nix/nixos/services/containers.nix
          ./nix/nixos/services/glances.nix
          ./nix/nixos/services/spice-qemu.nix
          ./nix/nixos/interfaces/i3.nix
          ./nix/nixos/programs/base-gui.nix
          ./nix/nixos/fonts.nix
        ];
        extraHomeModules = commonHomeModules ++ [
          ./nix/home/nix-index-db.nix
        ];
        linkDotfilesFromStore = true;
      };
    };

    darwinTargets = {
      chaos = {
        system = "aarch64-darwin";
        extraDarwinModules = [
          ./nix/darwin/homebrew.nix
          ./nix/darwin/settings.nix
        ];
        extraHomeModules = [
          ./nix/home/git.nix
          ./nix/home/nix-index-db.nix
          ./nix/home/zsh.nix
        ];
      };
    };

  in {

    nixosConfigurations = lib.genAttrs (builtins.attrNames nixosTargets) (name:
      let cfg = nixosTargets.${name};
      in mkNixOSConfig {
          system = cfg.system;
          extraNixOSModules = cfg.extraNixOSModules or [];
          extraHomeModules = cfg.extraHomeModules or [];
          linkDotfilesFromStore = cfg.linkDotfilesFromStore or false;
      });

    darwinConfigurations = lib.genAttrs (builtins.attrNames darwinTargets) (name:
      let cfg = darwinTargets.${name};
      in mkDarwinConfig {
          system = cfg.system;
          extraDarwinModules = cfg.extraDarwinModules or [];
          extraHomeModules = cfg.extraHomeModules or [];
          linkDotfilesFromStore = cfg.linkDotfilesFromStore or false;
      });

    homeConfigurations = lib.genAttrs (builtins.attrNames nixosTargets ++ builtins.attrNames darwinTargets) (name:
      let cfg = nixosTargets.${name} or darwinTargets.${name};
      in mkHomeConfig {
          system = cfg.system;
          extraHomeModules = cfg.extraHomeModules or [];
          linkDotfilesFromStore = cfg.linkDotfilesFromStore or false;
      });

  };
}

