# File sharing — KDE Connect + LocalSend
{ ... }: {
  flake.nixosModules.desktop = { ... }: {
    programs = {
      kdeconnect.enable = true;
      localsend.enable = true;
    };
  };
}
