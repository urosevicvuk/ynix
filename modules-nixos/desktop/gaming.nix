{pkgs, ...}: {
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    gamescope.enable = true;
    gamemode.enable = true;
  };

  hardware.steam-hardware.enable = true;
}
