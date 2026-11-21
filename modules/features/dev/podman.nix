{self, ...}: {
  flake.nixosModules.dev.imports = [self.nixosModules.podman];

  flake.nixosModules.podman = {
    pkgs,
    config,
    ...
  }: 
  {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };


    environment.systemPackages = with pkgs; [
      podman-compose
      podman-tui
      podman-desktop
    ];

    home-manager.sharedModules = [self.homeModules.podman];
  };

  flake.homeModules.podman = {...}: {
  };
}
