# OBS Studio
{ ... }:
{
  flake.nixosModules.obs = { config, pkgs, ... }: {
    home-manager.users.${config.preferences.username} = {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-pipewire-audio-capture
        ];
      };

      home.sessionVariables = {
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_ENABLE_HIGHDPI_SCALING = "1";
      };

      xdg.configFile."xdg-desktop-portal/hyprland.conf".text = ''
        [screencast]
        output_name=eDP-1
        max_fps=60
        allow_token_by_default=1
        restore_token=ask
      '';
    };
  };
}
