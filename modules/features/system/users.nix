{self, ...}: {
  # Self-registers into the `system` group (merged with the other system modules).
  flake.nixosModules.system.imports = [self.nixosModules.users];

  flake.nixosModules.users = {
    pkgs,
    config,
    ...
  }: {
    users = {
      defaultUserShell = pkgs.bash;
      users.${config.preferences.username} = {
        isNormalUser = true;
        description = "${config.preferences.username}";
        extraGroups = [
          "networkmanager"
          "wheel"
          "input"
          "libvirtd"
          "kvm"
        ];
      };
    };
  };
}
