# Discord via nixcord
{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.discord = {...}: {
    home-manager.sharedModules = [self.homeModules.discord];
  };

  flake.homeModules.discord = {config, ...}: let
    theme = config.theme.active;
  in {
    imports = [inputs.nixcord.homeModules.nixcord];

    stylix.targets.nixcord.enable = false;

    programs.nixcord = {
      enable = true;

      discord.vencord.enable = true;
      discord.openASAR.enable = false;

      vesktop.enable = true;
      config = {
        useQuickCss = true;
        frameless = true;
        themeLinks = [
          theme.discord-theme-url
        ];
      };
    };
  };

  # TODO: add concord - the TUI for Discord
}
