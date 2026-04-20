{
  flake.nixosModules.users = {
    pkgs,
    config,
    ...
  }: {
    programs.zsh.enable = true;
    users = {
      defaultUserShell = pkgs.zsh;
      users.${config.preferences.username} = {
        isNormalUser = true;
        description = "${config.preferences.username} account";
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
