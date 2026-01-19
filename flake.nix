{
  # https://github.com/urosevicvuk/nixos
  description = ''
    Goated nixos setup
  '';

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/25.05";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-fonts = {
      url = "github:Lyndeno/apple-fonts.nix";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
    };

    elephant = {
      url = "github:abenz1267/elephant";
    };

    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };

    affinity-nix = {
      url = "github:mrshmllow/affinity-nix";
    };

    # Secure Boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative disk partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # QuickShell - QtQuick-based widget toolkit (for end-4 bar only)
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    nixpkgs-stable,
    ...
  }: {
    # NixOS configurations
    nixosConfigurations = {
      # anorLondo is the main desktop system
      anorLondo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            _module.args = {inherit inputs;};

            nixpkgs.overlays = [
              (final: prev: {
                stable = import nixpkgs-stable {
                  system = final.system;
                  config.allowUnfree = true;
                };
              })
            ];
          }
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.lanzaboote.nixosModules.lanzaboote
          ./hosts/anorLondo/configuration.nix
        ];
      };

      # ariandel is the laptop
      ariandel = nixpkgs.lib.nixosSystem {
        modules = [
          {
            _module.args = {inherit inputs;};

            nixpkgs.overlays = [
              (final: prev: {
                stable = import nixpkgs-stable {
                  system = final.system;
                  config.allowUnfree = true;
                };
                # Material Symbols font for QuickShell icons
                material-symbols = prev.callPackage ./pkgs/material-symbols {};
              })
            ];
          }
          inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.disko.nixosModules.disko
          ./hosts/ariandel/configuration.nix
        ];
      };

      # firelink is the server
      firelink = nixpkgs.lib.nixosSystem {
        modules = [
          {
            _module.args = {inherit inputs;};
            nixpkgs.overlays = [inputs.nix-minecraft.overlay];
          }
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          # inputs.lanzaboote.nixosModules.lanzaboote  # Disabled for server
          inputs.nix-minecraft.nixosModules.minecraft-servers
          inputs.sops-nix.nixosModules.sops
          # inputs.nixarr.nixosModules.default  # Enable when nixarr input is added and configured
          # inputs.search-nixos-api.nixosModules.search-nixos-api  # Enable when search-nixos-api input is added
          ./hosts/firelink/configuration.nix
        ];
      };

      # bonfire - All-in-one cluster node (K3s control plane + worker + Longhorn storage)
      # Template for bonfire01, bonfire02, bonfire03
      bonfire = nixpkgs.lib.nixosSystem {
        modules = [
          {
            _module.args = {inherit inputs;};
            nixpkgs.overlays = [
              (final: prev: {
                stable = import nixpkgs-stable {
                  system = final.system;
                  config.allowUnfree = true;
                };
              })
            ];
          }
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.sops-nix.nixosModules.sops
          ./hosts/bonfire/configuration.nix
        ];
      };

      # bonfire-keeper - Dedicated control plane node (future separated architecture)
      bonfire-keeper = nixpkgs.lib.nixosSystem {
        modules = [
          {
            _module.args = {inherit inputs;};
            nixpkgs.overlays = [
              (final: prev: {
                stable = import nixpkgs-stable {
                  system = final.system;
                  config.allowUnfree = true;
                };
              })
            ];
          }
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.sops-nix.nixosModules.sops
          ./hosts/bonfire-keeper/configuration.nix
        ];
      };

      # bonfire-ash - Dedicated worker node (future separated architecture)
      bonfire-ash = nixpkgs.lib.nixosSystem {
        modules = [
          {
            _module.args = {inherit inputs;};
            nixpkgs.overlays = [
              (final: prev: {
                stable = import nixpkgs-stable {
                  system = final.system;
                  config.allowUnfree = true;
                };
              })
            ];
          }
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.sops-nix.nixosModules.sops
          ./hosts/bonfire-ash/configuration.nix
        ];
      };

      # bonfire-ember - Dedicated storage node (future Ceph deployment)
      bonfire-ember = nixpkgs.lib.nixosSystem {
        modules = [
          {
            _module.args = {inherit inputs;};
            nixpkgs.overlays = [
              (final: prev: {
                stable = import nixpkgs-stable {
                  system = final.system;
                  config.allowUnfree = true;
                };
              })
            ];
          }
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.sops-nix.nixosModules.sops
          ./hosts/bonfire-ember/configuration.nix
        ];
      };
    };
  };
}
