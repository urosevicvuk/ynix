# Nix build farm — offload compilation to firelink's Xeons.
#
# One module, two roles, gated on hostname (this evaluates per-host):
#   firelink  -> BUILDER: trusts the user so it accepts incoming remote builds.
#   everyone  -> CLIENT : ships Nix builds to firelink over ssh-ng.
#
# All hosts are x86_64-linux, so these are NATIVE builds — no emulation.
#
# Key trust: the LOCAL nix daemon runs as ROOT, so root ssh's to firelink using
# the user's existing (passphraseless) key — already authorized on firelink and
# already used by sops there. `accept-new` lets root's daemon trust firelink's
# host key on first contact without an interactive prompt.
{...}: {
  flake.nixosModules.buildFarm = {
    config,
    lib,
    ...
  }: let
    user = config.preferences.username;
    isBuilder = config.networking.hostName == "firelink";
    isClient = !isBuilder;
  in {
    # ---- CLIENT: offload to firelink ----
    nix.distributedBuilds = lib.mkIf isClient true;

    nix.buildMachines = lib.mkIf isClient [
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
    programs.ssh.extraConfig = lib.mkIf isClient ''
      Host firelink
        StrictHostKeyChecking accept-new
    '';

    nix.settings = {
      # Client: firelink pulls deps from its own caches, not shipped from us.
      builders-use-substitutes = lib.mkIf isClient true;
      # Builder: trust the user so its daemon accepts our remote builds.
      # (root is trusted implicitly and already declared elsewhere.)
      trusted-users = lib.mkIf isBuilder [user];
    };
  };
}
