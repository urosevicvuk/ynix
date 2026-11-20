{self, ...}: {
  # Disabled: the leading underscore keeps import-tree from loading this file.
  #
  # To switch the dev hosts from docker to podman:
  #   1. rename this file to podman.nix
  #   2. delete the `flake.nixosModules.dev.imports` line in docker.nix
  # Both are needed: nixpkgs asserts that dockerCompat cannot be on together
  # with virtualisation.docker.enable, and evaluation fails if they are.
  # Hosts importing nixosModules.docker directly (firelink) are unaffected.
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
