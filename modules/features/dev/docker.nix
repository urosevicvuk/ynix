{self, ...}: {
  # Self-registers into the `dev` group (merged with the other dev modules).
  flake.nixosModules.dev.imports = [self.nixosModules.docker];

  flake.nixosModules.docker = {
    pkgs,
    config,
    ...
  }: {
    virtualisation.docker.enable = true;

    users.users.${config.preferences.username}.extraGroups = ["docker"];

    environment.systemPackages = with pkgs; [
      docker-compose
    ];

    home-manager.sharedModules = [self.homeModules.docker];
  };

  flake.homeModules.docker = {...}: {
    programs.lazydocker = {
      enable = true;
    };
  };
}
