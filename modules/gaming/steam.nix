{self, ...}: {
  # Self-registers into the `gaming` group (merged with the other gaming modules).
  flake.nixosModules.gaming.imports = [self.nixosModules.steam];

  flake.nixosModules.steam = {pkgs, ...}: {
    programs = {
      steam = {
        enable = true;
        protontricks.enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;

        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      steamcmd
      steam-tui
      protonup-qt
    ];

    hardware.steam-hardware.enable = true;
  };
}
