{self, ...}: {
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
    programs.ssh.enable = true;

    # waypipe rides over ssh (`waypipe ssh anorlondo blender`) — kept here rather
    # than as a standalone one-package module. Harmless dead weight on firelink.
    home.packages = [pkgs.waypipe];
  };
}
