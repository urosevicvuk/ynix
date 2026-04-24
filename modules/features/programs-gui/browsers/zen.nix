{
  self,
  inputs,
  ...
}: {
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
