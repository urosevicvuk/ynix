# Discord via nixcord
{ inputs, ... }: {
  flake.homeModules.discord = { ... }: {
    imports = [ inputs.nixcord.homeModules.nixcord ];

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
          "https://raw.githubusercontent.com/shvedes/discord-gruvbox/refs/heads/main/gruvbox-dark.theme.css"
        ];
      };
    };
  };
}
