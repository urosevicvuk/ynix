{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.firelink = inputs.nixpkgs.lib.nixosSystem {
    modules = [self.nixosModules.firelink];
  };

  flake.nixosModules.firelink = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      self.nixosModules.system
      self.nixosModules.shell
      self.nixosModules.git
      self.nixosModules.llm-agents
      self.nixosModules.podman
      self.nixosModules.neovim
      self.nixosModules.server
      self.nixosModules.llm-agents

      self.nixosModules.sops

      # self.nixosModules.nixbot
    ];

    networking.hostName = "firelink";
    system.stateVersion = "24.05";

    boot.kernelModules = ["ipmi_si" "ipmi_devintf" "ipmi_watchdog"];
    boot.extraModprobeConfig = "options ipmi_watchdog action=reset";
    systemd.settings.Manager = {
      RuntimeWatchdogSec = "2min";
      RebootWatchdogSec = "5min";
    };

    boot.kernel.sysctl = {
      "kernel.panic" = 10;
      "kernel.panic_on_oops" = 1;
      "kernel.hardlockup_panic" = 1;
    };

    hardware.rasdaemon.enable = true;

    environment.systemPackages = [pkgs.ipmitool];

    home-manager.users.${config.preferences.username} = {
      home.packages = with pkgs; [
      ];
    };

    sops = {
      age.sshKeyPaths = ["/home/vyke/.ssh/id_ed25519"];
      defaultSopsFormat = "yaml";

      secrets = {
        #"cloudflare-tunnel-token" = {
        #  sopsFile = ../../secrets/server/cloudflare.yaml;
        #  key = "tunnel_token";
        #  mode = "0400";
        #};

        #"cloudflare-ddns-token" = {
        #  sopsFile = ../../secrets/server/cloudflare.yaml;
        #  key = "dns_token";
        #  mode = "0400";
        #};

        #"cloudflare-zone-id" = {
        #  sopsFile = ../../secrets/server/cloudflare.yaml;
        #  key = "zone_id";
        #  mode = "0400";
        #};
      };
    };
  };
}
