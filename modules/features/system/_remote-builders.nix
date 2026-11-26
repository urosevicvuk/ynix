{self, ...}: {
  flake.nixosModules.system.imports = [self.nixosModules.remoteBuilders];

  flake.nixosModules.remoteBuilders = {config, ...}: let
    user = config.preferences.username;
  in {
    nix.distributedBuilds = true;

    nix.buildMachines = [
      {
        hostName = "firelink";
        protocol = "ssh-ng";
        sshUser = user;
        sshKey = "/home/${user}/.ssh/id_ed25519";
        system = "x86_64-linux";
        maxJobs = 16;
        speedFactor = 2;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      }
    ];

    programs.ssh.extraConfig = ''
      Host firelink
        StrictHostKeyChecking accept-new
    '';

    nix.settings.builders-use-substitutes = true;
  };
}
