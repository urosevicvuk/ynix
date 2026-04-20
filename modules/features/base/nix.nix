{inputs, ...}: {
  flake.nixosModules.nix = {config, ...}: {
    nixpkgs.config.allowUnfree = true;
    nix = {
      nixPath = ["nixpkgs=${inputs.nixpkgs}"];
      channel.enable = false;
      extraOptions = "warn-dirty = false";
      settings = {
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [
          "https://cache.nixos.org?priority=10"
          "https://hyprland.cachix.org"
          "https://nix-community.cachix.org"
          "https://numtide.cachix.org"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        ];
      };
      gc = {
        automatic = true;
        persistent = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };
    programs.nh = {
      enable = true;
      flake = config.preferences.configDirectory;
    };
    system.autoUpgrade = {
      enable = false;
      dates = "04:00";
      flake = config.preferences.configDirectory;
      flags = [
        "--update-input"
        "nixpkgs"
        "--commit-lock-file"
      ];
      allowReboot = false;
    };
  };
}
