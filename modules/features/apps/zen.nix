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

    # Off on purpose. Theming zen through stylix needs
    # `stylix.targets.zen-browser.profileNames`, which makes HM generate
    # ~/.zen/profiles.ini with Path=<profile name> — that would orphan the
    # existing "9o2zdukk.Default Profile" directory. Zen keeps its in-browser
    # theme instead. To turn it on, pin the path so nothing is orphaned:
    #   stylix.targets.zen-browser.profileNames = ["Default Profile"];
    #   programs.zen-browser.profiles."Default Profile".path = "9o2zdukk.Default Profile";
    stylix.targets.zen-browser.enable = false;
  };
}
