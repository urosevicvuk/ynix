{
  self,
  inputs,
  ...
}: {
  # Self-registers into the `apps` group (merged with the other apps modules).
  flake.nixosModules.apps.imports = [self.nixosModules.zen];

  flake.nixosModules.zen = {...}: {
    home-manager.sharedModules = [self.homeModules.zen];
  };

  flake.homeModules.zen = {pkgs, ...}: {
    imports = [
      inputs.zen-browser.homeModules.beta
    ];

    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
    };
  };
}
