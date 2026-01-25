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

    # Storage node packages (Ceph management)
    packages = with pkgs; [
      # System utilities
      htop
      iotop # Disk I/O monitoring
      curl
      wget

      # Ceph tools
      ceph # Ceph CLI
      # ceph-dashboard  # Web UI for Ceph monitoring

      # Disk utilities
      smartmontools # Disk health monitoring
      nvme-cli # NVMe management
    ];

    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
