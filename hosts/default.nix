{inputs, ...}: let
  mkPkgsStable = system:
    import inputs.nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };

  mkHost = {
    configPath,
    extraModules ? [],
  }:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        pkgs-stable = mkPkgsStable "x86_64-linux";
      };
      modules =
        [
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.sops-nix.nixosModules.sops
        ]
        ++ extraModules
        ++ [configPath];
    };
in {
  flake.nixosConfigurations = {
    # Main desktop machine
    anorLondo = mkHost {
      configPath = ./anorLondo/configuration.nix;
      extraModules = [];
    };

    # Framework laptop
    ariandel = mkHost {
      configPath = ./ariandel/configuration.nix;
      extraModules = [
        inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.disko.nixosModules.disko
        inputs.determinate.nixosModules.default
      ];
    };

    # Single-node server
    firelink = mkHost {
      configPath = ./firelink/configuration.nix;
      extraModules = [];
    };

    #bonfire = mkHost {
    #  configPath = ./bonfire/configuration.nix;
    #  extraModules = [inputs.sops-nix.nixosModules.sops];
    #};
    #bonfire-keeper = mkHost {
    #  configPath = ./bonfire/keeper/configuration.nix;
    #  extraModules = [inputs.sops-nix.nixosModules.sops];
    #};
    #bonfire-ash = mkHost {
    #  configPath = ./bonfire/ash/configuration.nix;
    #  extraModules = [inputs.sops-nix.nixosModules.sops];
    #};
    #bonfire-ember = mkHost {
    #  configPath = ./bonfire/ember/configuration.nix;
    #  extraModules = [inputs.sops-nix.nixosModules.sops];
    #};
  };
}
