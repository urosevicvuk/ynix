{self, ...}: {
  flake.nixosModules.editorconfig = {...}: {
    home-manager.sharedModules = [self.homeModules.editorconfig];
  };

  flake.homeModules.editorconfig = {...}: {
    editorconfig = {
      enable = true;
      settings = {
        "*" = {
          indent_style = "space";
          indent_size = 4;
        };

        "*.nix".indent_size = 2;

        "*.{c,js,ts,json,yaml,css}".indent_size = 2;
      };
    };
  };
}
