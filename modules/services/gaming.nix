{ ... }:
{
  flake.modules.nixos.services = [
    (
      { ... }:
      {
        programs = {
          steam = {
            enable = true;
            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
          };
          gamescope.enable = true;
          gamemode = {
            enable = true;
            settings = {
              gpu = {
                apply_gpu_optimisations = "accept-responsibility";
                gpu_device = 0;
                amd_performance_level = "high";
              };
            };
          };
        };

        hardware.steam-hardware.enable = true;
      }
    )
  ];
}
