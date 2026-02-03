# Hyprpaper is used to set the wallpaper on the system
# Disabled - using noctalia wallpaper management instead
{lib, ...}: {
  services.hyprpaper = {
    enable = lib.mkForce false;
  };
}
