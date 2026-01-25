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

    # Control plane management tools
    packages = with pkgs; [
      # System utilities
      htop
      curl
      wget

      # Kubernetes management
      kubectl
      kubernetes-helm
      k9s
      kubectx
      stern

      # Cluster administration
      etcdctl
    ];

    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
