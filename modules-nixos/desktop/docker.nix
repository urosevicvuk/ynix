{
  config,
  pkgs,
  ...
}: let
  inherit (config.var) username;
in {
  virtualisation.docker = {
    enable = true;
  };

  users.users.${username}.extraGroups = ["docker"];

  environment.systemPackages = with pkgs; [
    lazydocker
    docker-compose
  ];
}
