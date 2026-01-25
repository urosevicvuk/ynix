{config, ...}: let
  inherit (config.var) timeZone;
  inherit (config.var) defaultLocale;
  inherit (config.var) extraLocale;
  inherit (config.var) keyboardLayout;
  inherit (config.var) keyboardVariant;
in {
  # Time zone
  time = {
    inherit timeZone;
  };

  # Locale settings
  i18n.defaultLocale = defaultLocale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = extraLocale;
    LC_IDENTIFICATION = extraLocale;
    LC_MEASUREMENT = extraLocale;
    LC_MONETARY = extraLocale;
    LC_NAME = extraLocale;
    LC_NUMERIC = extraLocale;
    LC_PAPER = extraLocale;
    LC_TELEPHONE = extraLocale;
    LC_TIME = extraLocale;
  };

  # X server keyboard layout (used by many applications)
  services.xserver = {
    enable = true;
    xkb = {
      layout = keyboardLayout;
      variant = keyboardVariant;
      options = "grp:alt_space_toggle";
    };
  };

  # Console keyboard layout
  console.keyMap = "us";
}
