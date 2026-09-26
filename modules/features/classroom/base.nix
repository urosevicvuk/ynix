{self, ...}: {
  # Self-registers into the `classroom` group (merged with the other classroom modules).
  #
  # The classroom host deliberately shares NOTHING with the `system` group: that
  # group carries a personal SSH key, tailnet hostnames, an X server and a
  # browser, none of which belong in an image handed to thirty students.
  flake.nixosModules.classroom.imports = [self.nixosModules.classroom-base];

  flake.nixosModules.classroom-base = {lib, ...}: {
    nixpkgs.config.allowUnfree = true;

    nix = {
      channel.enable = false;
      settings = {
        experimental-features = ["nix-command" "flakes"];
        auto-optimise-store = true;
      };
      # Students never rebuild this image, and a GC timer firing mid-lecture is
      # pure downside.
      gc.automatic = false;
    };

    time.timeZone = "Europe/Belgrade";
    i18n.defaultLocale = "en_US.UTF-8";

    networking = {
      hostName = "lab";
      # Plain DHCP. NetworkManager is wifi/desktop machinery a NAT'd VM does not
      # need, and `ip`/`ss` are what they will meet on a real server anyway.
      useDHCP = lib.mkDefault true;
      networkmanager.enable = false;
      # Off on purpose: this is a disposable single-user lab behind VM NAT, and
      # the syllabus is git/CI/docker/k8s, not iptables. Leaving it on turns
      # every NodePort exercise into a firewall debugging session.
      firewall.enable = false;
    };

    boot.tmp.cleanOnBoot = true;
  };
}
