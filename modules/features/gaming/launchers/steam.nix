{...}: {
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
