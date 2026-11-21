{self, ...}: {
  flake.nixosModules.server.imports = [self.nixosModules.buildServer];

  flake.nixosModules.buildServer = {
    config,
    lib,
    ...
  }: {
    nix.settings.trusted-users = [config.preferences.username];

    nix.distributedBuilds = lib.mkForce false;
    nix.buildMachines = lib.mkForce [];
  };
}
