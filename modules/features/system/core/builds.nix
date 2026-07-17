# Remote builders — CLIENT half. Every host offloads Nix builds to firelink's
# Xeons; firelink's accepting half is server/build-server.nix (and it opts back
# out of being a client there, so it never builds on itself).
#
# All hosts are x86_64-linux, so these are NATIVE builds — no emulation.
#
# Key trust: the LOCAL nix daemon runs as ROOT, so root ssh's to firelink using
# the user's existing (passphraseless) key — already authorized on firelink and
# already used by sops there. `accept-new` lets root's daemon trust firelink's
# host key on first contact without an interactive prompt.
{...}: {
  flake.nixosModules.remoteBuilders = {config, ...}: let
    user = config.preferences.username;
  in {
    nix.distributedBuilds = true;

    nix.buildMachines = [
      {
        hostName = "firelink"; # resolved via networking.hosts / the tailnet
        protocol = "ssh-ng";
        sshUser = user;
        sshKey = "/home/${user}/.ssh/id_ed25519";
        system = "x86_64-linux";
        maxJobs = 16; # dual-socket Xeon; bump to match real thread count
        speedFactor = 2;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      }
    ];

    # Let root's build daemon trust firelink's host key on first connect.
    programs.ssh.extraConfig = ''
      Host firelink
        StrictHostKeyChecking accept-new
    '';

    # firelink pulls deps from its own caches, not shipped from us.
    nix.settings.builders-use-substitutes = true;
  };
}
