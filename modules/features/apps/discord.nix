# Discord via nixcord
{
  self,
  inputs,
  ...
}: {
  # Self-registers into the `apps` group (merged with the other apps modules).
  flake.nixosModules.apps.imports = [self.nixosModules.discord];

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

      # Route screen-share capture through the PipeWire portal stream.
      # Without this the official client falls back to its native (X11)
      # capturer on Wayland, which yields no frames and Discord drops the
      # stream with "4022 Call terminated" right after capture starts.
      discord.commandLineArgs = [
        "--enable-features=WebRTCPipeWireCapturer"
      ];

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
