{ ... }:
{
  flake.nixosModules.filesharing = { ... }: {
        programs = {
          kdeconnect.enable = true;
          localsend.enable = true;
        };
  };
}
