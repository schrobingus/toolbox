
{
  description = "Personal Nix Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
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
    # tex2nix = {
    #   url = "github:rgri/tex2nix";
    #   inputs.utils.follows = "nixpkgs";
    # };
    agenix.url = "github:ryantm/agenix";
    # nixvim-config.url = "github:schrobingus/nixvim-config";
    nixvim-config.url = "path:/Users/brent/Sources/nvim-config";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-index-database, agenix, nixvim-config, ... } @ inputs: let

    lib = nixpkgs.lib;

    info = system: let
      username = "brent";
      homeDir =
        if builtins.match ".*-darwin" system != null
          then "/Users/${username}"
        else "/home/${username}";
      dotfilesDir = "${homeDir}/Sources/dotfiles";
    in { inherit username homeDir dotfilesDir; };

    homeManagerConfig = { pkgs, system, extraHomeModules ? [], dotfilesUseStore ? false }: {
      # TODO: move the nvim stuff into it's own home module for organization
      home.packages = [
        pkgs.home-manager
        inputs.nixvim-config.packages.${system}.default
        # inputs.tex2nix.defaultPackage.${system}
      ];
      home.sessionVariables = {
        EDITOR = "nvim";
      };
      imports = [
        ./nix/home/default.nix
        (if dotfilesUseStore
          then ./nix/home/files-store.nix
          else ./nix/home/files.nix)
      ] ++ extraHomeModules;
    };

    mkNixOSConfig = { system, extraHomeModules ? [], extraNixOSModules ? [], dotfilesUseStore ? false }: let
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
              dotfilesUseStore = dotfilesUseStore;
            };
          }
        ] ++ extraNixOSModules;
      };

    mkDarwinConfig = { system, extraHomeModules ? [], extraDarwinModules ? [], dotfilesUseStore ? false }: let
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
                dotfilesUseStore = dotfilesUseStore;
              };
            }
          ];
      };

    mkHomeConfig = { system, extraHomeModules ? [], dotfilesUseStore ? false }: let
      pkgs = import nixpkgs { inherit system; };
    in home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        extraSpecialArgs = { inherit self; } // info system;
        modules = [
          homeManagerConfig {
            inherit pkgs system extraHomeModules;
            dotfilesUseStore = dotfilesUseStore;
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
            system.stateVersion = "25.05";
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

      thonk = {
        system = "x86_64-linux";
        extraNixOSModules = [
          {
            networking.hostName = "thonk";
          }
          ./nix/nixos/bootloaders/grub-efi.nix
          ./nix/nixos/hardware-configuration/x131e-chromebook.nix
          ./nix/nixos/interfaces/i3.nix
          ./nix/nixos/programs/base-gui.nix
          ./nix/nixos/fonts.nix
        ] ++ commonBaseCliModules;
        extraHomeModules = commonHomeModules ++ [
          ./nix/home/fonts.nix
          ./nix/home/xresources.nix
          ./nix/home/dunst.nix
        ];
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
          ./nix/nixos/services/glances.nix
          ./nix/nixos/services/spice-qemu.nix
          ./nix/nixos/interfaces/i3.nix
          ./nix/nixos/programs/base-gui.nix
          ./nix/nixos/fonts.nix
        ];
        extraHomeModules = commonHomeModules ++ [
          ./nix/home/nix-index-db.nix
        ];
        dotfilesUseStore = true;
      };

      tendollarhaircut = {
        system = "x86_64-linux";
        extraNixOSModules = [
          {
            networking.hostName = "tendollarhaircut";
          }
          ./nix/nixos/bootloaders/grub-efi.nix
          ./nix/nixos/hardware-configuration/tendollarhaircut.nix
          ./nix/nixos/interfaces/i3.nix
          ./nix/nixos/programs/base-gui.nix
          ./nix/nixos/fonts.nix
        ] ++ commonBaseCliModules;
        extraHomeModules = commonHomeModules ++ [
          ./nix/home/fonts.nix
          ./nix/home/xresources.nix
          ./nix/home/dunst.nix
        ];
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
          dotfilesUseStore = cfg.dotfilesUseStore or false;
        });

    darwinConfigurations = lib.genAttrs (builtins.attrNames darwinTargets) (name:
      let cfg = darwinTargets.${name};
      in mkDarwinConfig {
          system = cfg.system;
          extraDarwinModules = cfg.extraDarwinModules or [];
          extraHomeModules = cfg.extraHomeModules or [];
          dotfilesUseStore = cfg.dotfilesUseStore or false;
        });

    homeConfigurations = lib.genAttrs (builtins.attrNames nixosTargets ++ builtins.attrNames darwinTargets) (name:
      let cfg = nixosTargets.${name} or darwinTargets.${name};
      in mkHomeConfig {
          system = cfg.system;
          extraHomeModules = cfg.extraHomeModules or [];
          dotfilesUseStore = cfg.dotfilesUseStore or false;
        });

  };
}
