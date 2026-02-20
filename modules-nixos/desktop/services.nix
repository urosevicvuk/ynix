{pkgs, ...}: {
  services = {
    dbus = {
      enable = true;
      implementation = "broker";
      packages = with pkgs; [gcr];
    };

    upower.enable = true;
    libinput.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };
}
