{
  config,
  pkgs,
  ...
}: let
  inherit (config.var) username;
in {
  programs.zsh.enable = true;
  users = {
    defaultUserShell = pkgs.zsh;
    users.${username} = {
      isNormalUser = true;
      description = "${username} account";
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "libvirtd"
        "kvm"
      ];
    };
  };
}
