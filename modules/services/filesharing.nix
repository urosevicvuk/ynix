{ ... }:
{
  flake.nixosModules.services = { ... }: {
        programs = {
          kdeconnect.enable = true;
          localsend.enable = true;
        };
  };
}
