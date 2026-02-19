{config, ...}: let
  inherit (config.var) configDirectory;
  inherit (config.var) autoUpgrade;
in {
  # System auto-upgrade configuration
  system.autoUpgrade = {
    enable = autoUpgrade;
    dates = "04:00";
    flake = "${configDirectory}";
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
    ];
    allowReboot = false;
  };
}
