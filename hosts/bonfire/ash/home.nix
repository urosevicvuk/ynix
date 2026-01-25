{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    ../../modules-home/programs/shell
    ../../modules-home/programs/git.nix
    ../../modules-home/programs/nvf
    ../../secrets/shared
    ./variables.nix
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    # Minimal worker packages (mostly monitoring/debugging)
    packages = with pkgs; [
      # System utilities
      htop
      curl
      wget

      # Container debugging
      kubectl # For debugging pods on this node
      docker-compose
    ];

    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
