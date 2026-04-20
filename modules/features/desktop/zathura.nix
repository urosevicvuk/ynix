# Zathura - PDF viewer
{self, ...}: {
  flake.nixosModules.zathura = {...}: {
    home-manager.sharedModules = [self.homeModules.zathura];
  };

  flake.homeModules.zathura = {...}: {
    programs.zathura = {
      enable = true;

      options = {
        guioptions = "v";
        adjust-open = "width";
        statusbar-basename = true;
        render-loading = false;
        scroll-step = 120;
      };
    };
  };
}
