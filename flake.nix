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

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

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
  }: let
    # Centralized package sets - define once, use everywhere
    forAllSystems = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"];

    mkPkgsUnstable = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    mkPkgsStable = system:
      import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
  in {
    # NixOS configurations
    nixosConfigurations = {
      # anorLondo is the main desktop system
      anorLondo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          pkgs-stable = mkPkgsStable "x86_64-linux";
        };
        modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.lanzaboote.nixosModules.lanzaboote
          ./hosts/anorLondo/configuration.nix
        ];
      };

      # ariandel is the laptop
      ariandel = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          pkgs-stable = mkPkgsStable "x86_64-linux";
        };
        modules = [
          inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.disko.nixosModules.disko
          inputs.determinate.nixosModules.default
          ./hosts/ariandel/configuration.nix
        ];
      };

      # firelink is the server (stable base)
      firelink = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          pkgs-unstable = mkPkgsUnstable "x86_64-linux";
        };
        modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          # inputs.lanzaboote.nixosModules.lanzaboote  # Disabled for server
          inputs.sops-nix.nixosModules.sops
          # inputs.nixarr.nixosModules.default  # Enable when nixarr input is added and configured
          # inputs.search-nixos-api.nixosModules.search-nixos-api  # Enable when search-nixos-api input is added
          ./hosts/firelink/configuration.nix
        ];
      };

      # bonfire - All-in-one cluster node (K3s control plane + worker + Longhorn storage)
      # Template for bonfire01, bonfire02, bonfire03
      bonfire = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          pkgs-stable = mkPkgsStable "x86_64-linux";
        };
        modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.sops-nix.nixosModules.sops
          ./hosts/bonfire/configuration.nix
        ];
      };

      # bonfire-keeper - Dedicated control plane node (future separated architecture)
      bonfire-keeper = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          pkgs-stable = mkPkgsStable "x86_64-linux";
        };
        modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.sops-nix.nixosModules.sops
          ./hosts/bonfire-keeper/configuration.nix
        ];
      };

      # bonfire-ash - Dedicated worker node (future separated architecture)
      bonfire-ash = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          pkgs-stable = mkPkgsStable "x86_64-linux";
        };
        modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.sops-nix.nixosModules.sops
          ./hosts/bonfire-ash/configuration.nix
        ];
      };

      # bonfire-ember - Dedicated storage node (future Ceph deployment)
      bonfire-ember = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          pkgs-stable = mkPkgsStable "x86_64-linux";
        };
        modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.sops-nix.nixosModules.sops
          ./hosts/bonfire-ember/configuration.nix
        ];
      };
    };
  };
}
