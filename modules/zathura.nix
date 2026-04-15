# Zathura - PDF viewer
{ ... }:
{
  flake.nixosModules.zathura = { config, ... }: {
    home-manager.users.${config.preferences.username} = {
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
  };
}
