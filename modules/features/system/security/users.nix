{
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
