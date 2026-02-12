{pkgs, ...}: {
  # Desktop-related system services
  services = {
    #D-Bus message bus
    dbus = {
      enable = true;
      implementation = "broker";
      packages = with pkgs; [
        gcr
        #gnome-settings-daemon
      ];
    };

    # Virtual filesystem support (USB drives, etc.)
    #gvfs.enable = true;

    # Battery status reporting (needed by Noctalia battery widget)
    upower.enable = true;

    # Disk management
    #udisks2.enable = true;

    # Input device configuration (touchpad, etc.)
    libinput.enable = true;

    # GNOME keyring for password storage
    #gnome.gnome-keyring.enable = true;
    #gnome.evolution-data-server.enable = true;

    # Geolocation service (required for illogical-impulse/QuickShell QtPositioning)
    #geoclue2.enable = true;

    #Profile Sync Daemon - moves browser profiles to tmpfs
    #psd = {
    #  enable = true;
    #  resyncTimer = "10m";
    #};
  };

  programs = {
    #dconf.enable = true;

    # GPU Screen Recorder - enables promptless recording (no polkit prompt)
    #gpu-screen-recorder.enable = true;
  };

  # Enable graphics support
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd # For DaVinci Resolve
    ];
  };
}
