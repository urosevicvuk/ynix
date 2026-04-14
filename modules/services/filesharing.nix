{ ... }:
{
  flake.modules.nixos.services = [
    (
      { ... }:
      {
        programs = {
          kdeconnect.enable = true;
          localsend.enable = true;
        };
      }
    )
  ];
}
