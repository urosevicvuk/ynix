{
  config,
  pkgs,
  ...
}: let
  inherit (config.var) hostname;
in {
  networking = {
    firewall = {
      enable = true;
      allowPing = false;
    };
    hostName = hostname;
    networkmanager = {
      enable = true;
      wifi = {
        # Disable power saving - this causes disconnects
        powersave = false;
        ## Reduce background scanning
        scanRandMacAddress = false;
        ## Disable MAC randomization completely
        macAddress = "preserve";
      };
    };
  };

  #systemd.services.NetworkManager-wait-online.enable = false;

  # Disable WiFi power management at system level
  boot.extraModprobeConfig = ''
    options mt7925e disable_aspm=1
  '';

  ## Keep WiFi active
  powerManagement.enable = true;
  #services.udev.extraRules = ''
  #  # Disable power management for WiFi
  #  ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlp*", RUN+="${pkgs.iw}/bin/iw dev $name set power_save off"
  #'';
}
