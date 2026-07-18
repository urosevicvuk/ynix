# Sunshine — GPU desktop/game stream host. anorlondo ONLY (it has the AMD GPU;
# firelink is headless, ariandel is the Moonlight *client*). Imported directly
# from anorLondo/configuration.nix, not from the shared desktop group.
#
# Pair from Moonlight over the tailnet (use anorlondo's tailscale IP) so it works
# on the couch and remotely. First pairing: browse to https://<host>:47990.
{...}: {
  flake.nixosModules.sunshine = {pkgs, ...}: {
    services.sunshine = {
      enable = true;
      autoStart = true;
      # niri is a non-wlroots compositor -> KMS screen capture needs CAP_SYS_ADMIN.
      capSysAdmin = true;
      openFirewall = true;
    };

    # AMD VAAPI/AMF hardware H.264/HEVC encode. The libva stack is already pulled
    # in by the graphics module; this just makes the encoder tooling present.
    environment.systemPackages = [pkgs.libva-utils];
  };
}
