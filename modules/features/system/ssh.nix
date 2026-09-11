{self, ...}: {
  flake.nixosModules.system.imports = [self.nixosModules.ssh];

  flake.nixosModules.ssh = {config, ...}: {
    programs.mosh.enable = true;
    services.openssh = {
      enable = true;
      ports = [22];
      openFirewall = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        AllowUsers = [config.preferences.username];
      };
    };
    users.users.${config.preferences.username}.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQpgKiftVTzqkfu6zbRpvZFtWZH/HBQSj6DhuVvVRul vuk23urosevic@gmail.com"
    ];

    home-manager.sharedModules = [self.homeModules.ssh];
  };

  flake.homeModules.ssh = {pkgs, ...}: {
    services.ssh-agent.enable = true;
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings."*" = {
        AddKeysToAgent = "yes";
        ServerAliveInterval = 60;
        ServerAliveCountMax = 3;
        ControlMaster = "auto";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "10m";
      };
    };

    home.packages = [pkgs.waypipe];
  };
}
