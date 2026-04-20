{...}: {
  flake.nixosModules.gamemode = {...}: {
    programs = {
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
  };
}
