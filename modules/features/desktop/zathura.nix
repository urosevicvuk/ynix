# Zathura - PDF viewer
{
  self,
  ...
}:
{
  flake.homeModules.zathura =
    { ... }:
    {
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

  flake.nixosModules.zathura =
    { ... }:
    {
      home-manager.sharedModules = [ self.homeModules.zathura ];
    };
}
