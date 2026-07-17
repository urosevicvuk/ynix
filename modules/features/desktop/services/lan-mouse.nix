# Lan Mouse — software KVM between ariandel and anorLondo.
# Peers talk over tailscale (hosts entries from the tailscale module), so the
# traffic lands on the trusted tailscale0 interface and no firewall port is
# opened here. Owns the HM bridge; the home facet does the actual work.
{self, ...}: {
  flake.nixosModules.lan-mouse = {
    home-manager.sharedModules = [self.homeModules.lan-mouse];
  };

  flake.homeModules.lan-mouse = {
    pkgs,
    osConfig,
    ...
  }: let
    # Each host lists the other as its client, placed by physical layout:
    # ariandel (laptop) sits below anorLondo's monitor.
    peer =
      {
        ariandel = {
          hostname = "anorlondo";
          position = "top";
        };
        anorLondo = {
          hostname = "ariandel";
          position = "bottom";
        };
      }
      .${osConfig.networking.hostName};
  in {
    home.packages = [pkgs.lan-mouse];

    xdg.configFile."lan-mouse/config.toml".text = ''
      port = 4242

      # Peers must be authorized by certificate fingerprint. Each host prints
      # its own fingerprint on daemon startup (journalctl --user -u lan-mouse,
      # also shown in the GUI settings); paste it on the *other* host below,
      # then rebuild.
      [authorized_fingerprints]
      # "aa:bb:cc:..." = "${peer.hostname}"

      [[clients]]
      hostname = "${peer.hostname}"
      position = "${peer.position}"
      activate_on_startup = true
    '';

    systemd.user.services.lan-mouse = {
      Unit = {
        Description = "Lan Mouse daemon";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };
      Service = {
        ExecStart = "${pkgs.lan-mouse}/bin/lan-mouse daemon";
        Restart = "on-failure";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
