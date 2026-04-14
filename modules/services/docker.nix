{ ... }:
{
  flake.modules.nixos.services = [
    (
      { pkgs, ... }:
      {
        virtualisation.docker.enable = true;

        users.users.vyke.extraGroups = [ "docker" ];

        environment.systemPackages = with pkgs; [
          lazydocker
          docker-compose
        ];
      }
    )
  ];
}
