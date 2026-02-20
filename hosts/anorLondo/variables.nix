{ config, lib, ... }:
{
  imports = [
    # Theme import
    ../../themes/gruvbox.nix
  ];
  config.var = {
    hostname = "anorLondo";
    username = "vyke";
    configDirectory = "/home/" + config.var.username + "/nixos"; # The path of the nixos configuration directory

    device = "desktop"; # laptop || desktop || server
    terminal = "kitty"; # default terminal emulator - kitty || ghostty

    keyboardLayout = "us,rs,rs";
    keyboardVariant = ",latin,";

    location = "Belgrade";
    timeZone = "Europe/Belgrade";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "en_US.UTF-8";

    git = {
      username = "urosevicvuk";
      email = "vuk23urosevic@gmail.com";
    };

    autoUpgrade = false;
    autoGarbageCollector = true;

    # Display and input settings (desktop-specific)
    monitorScale = "1";
    inputSensitivity = "-0.5";

};

  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
