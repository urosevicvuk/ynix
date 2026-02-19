{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../modules-home/core
    ../../modules-home/nvim
    ../../secrets/shared
    ./variables.nix
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      jq
      just
      wireguard-tools

      # Utils
      nh
      zip
      unzip
      optipng
      fastfetch
      btop
      tailscale

      claude-code
    ];

    # Don't touch this
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
