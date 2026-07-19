{self, ...}: {
  # Self-registers into the `apps` group (merged with the other apps modules).
  flake.nixosModules.apps.imports = [self.nixosModules.ghostty];

  flake.nixosModules.ghostty = {...}: {
    home-manager.sharedModules = [self.homeModules.ghostty];
  };

  flake.homeModules.ghostty = {...}: {
    programs.ghostty = {
      enable = true;
      installVimSyntax = true;
      installBatSyntax = true;
      systemd.enable = true;

      settings = {
        command = "nu";
        shell-integration = "nushell";

        window-padding-x = 6;
        window-padding-y = 6;
        window-padding-balance = true;
        window-padding-color = "extend";
      };
    };
  };
}
