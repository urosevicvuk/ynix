{ ... }:
{
  flake.nixosModules.docker = { pkgs, config, ... }: {
        virtualisation.docker.enable = true;

        users.users.${config.preferences.username}.extraGroups = [ "docker" ];

        environment.systemPackages = with pkgs; [
          lazydocker
          docker-compose
        ];
  };
}
