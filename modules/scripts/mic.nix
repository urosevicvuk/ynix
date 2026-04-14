{ ... }:
{
  flake.modules.homeManager.scripts = [
    (
      { pkgs, ... }:
      let
        increments = "5";

        mic-change = pkgs.writeShellScriptBin "mic-change" ''
          [[ $1 == "mute" ]] && wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
          [[ $1 == "up" ]] && wpctl set-volume @DEFAULT_AUDIO_SOURCE@ ''${2-${increments}}%+
          [[ $1 == "down" ]] && wpctl set-volume @DEFAULT_AUDIO_SOURCE@ ''${2-${increments}}%-
          [[ $1 == "set" ]] && wpctl set-volume @DEFAULT_AUDIO_SOURCE@ ''${2-100}%
        '';

        mic-up = pkgs.writeShellScriptBin "mic-up" ''
          mic-change up ${increments}
        '';

        mic-set = pkgs.writeShellScriptBin "mic-set" ''
          mic-change set ''${1-100}
        '';

        mic-down = pkgs.writeShellScriptBin "mic-down" ''
          mic-change down ${increments}
        '';

        mic-toggle = pkgs.writeShellScriptBin "mic-toggle" ''
          mic-change mute
        '';
      in
      {
        home.packages = [
          mic-change
          mic-up
          mic-down
          mic-toggle
          mic-set
        ];
      }
    )
  ];
}
