{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../../modules-home/core
    ../../../modules-home/nvim
    ../../../secrets/shared
    ./variables.nix
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      htop
      iotop
      curl
      wget
      ceph
      smartmontools
      nvme-cli
    ];

    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
