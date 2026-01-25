{pkgs, ...}: {
  # Printing configuration
  services.printing = {
    enable = true;
    #drivers = with pkgs; [
    #  gutenprint
    #  hplip
    #  epson-escpr
    #  epson-escpr2
    #  # Konica Minolta drivers (foomatic includes support for many business printers)
    #  foomatic-db-ppds-withNonfreeDb
    #  ghostscript
    #];
    #startWhenNeeded = true;
  };

  # Network printer discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Scanner configuration (SANE)
  #hardware.sane = {
  #  enable = true;
  #  # Enable network scanning
  #  extraBackends = with pkgs; [
  #    sane-airscan # For AirScan/eSCL protocol (modern network scanners)
  #  ];
  #  # Enable backend for network scanners
  #  netConf = "192.168.1.72";
  #};

  ## Add user to scanner group automatically
  #users.groups.scanner.members = ["vyke"];

  ## GUI for printer management
  #programs.system-config-printer.enable = true;

  ## Scanner GUI applications
  #environment.systemPackages = with pkgs; [
  #  simple-scan # GNOME's simple scanner app
  #  xsane # Advanced scanning interface
  #];
}
