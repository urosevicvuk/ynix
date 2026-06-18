{...}: {
  flake.nixosModules.steam = {...}: {
    programs = {
      steam = {
        enable = true;
        protontricks.enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };
    };

    hardware.steam-hardware.enable = true;
  };
}
