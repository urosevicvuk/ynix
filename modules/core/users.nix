{
  flake.modules.nixos.core = [
    (
      { pkgs, ... }:
      {
        programs.zsh.enable = true;
        users = {
          defaultUserShell = pkgs.zsh;
          users.vyke = {
            isNormalUser = true;
            description = "vyke account";
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
    )
  ];
}
