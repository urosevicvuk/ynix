{
  pkgs,
  config,
  ...
}: let
  inherit (config.var) configDirectory;
in {
  environment = {
    # Environment variables
    variables = {
      XDG_DATA_HOME = "$HOME/.local/share";
      NH_FLAKE = configDirectory;
      PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
      EDITOR = "nvim";
      TERMINAL = config.var.terminal;
      TERM = config.var.terminal;
      BROWSER = "zen-beta";
      PULSE_LATENCY_MSEC = 60;
    };

    # Essential system packages
    systemPackages = with pkgs; [
      fd
      bc
      gcc
      git-ignore
      xdg-utils
      wget
      curl
      vim
      nixfmt
      sops
      age
    ];

    # Enable zsh autocompletion for system packages (systemd, etc)
    pathsToLink = ["/share/zsh"];
  };

  # Faster rebuilding - disable unnecessary documentation
  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
    info.enable = false;
    nixos.enable = false;
  };
}
