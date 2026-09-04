# Noctalia Shell - Wayland desktop shell built with QuickShell
{
  self,
  inputs,
  ...
}: {
  # Self-registers into the `desktop` group (merged with the other desktop modules).
  flake.nixosModules.desktop.imports = [self.nixosModules.noctalia];

  flake.nixosModules.noctalia = {pkgs, ...}: {
    home-manager.sharedModules = [self.homeModules.noctalia];
  };

  flake.homeModules.noctalia = {...}: {
    imports = [inputs.noctalia.homeModules.default];

    programs.noctalia = {
      enable = true;
    };
  };
}
