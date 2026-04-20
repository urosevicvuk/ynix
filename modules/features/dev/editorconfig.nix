{
  self,
  ...
}:
{
  flake.homeModules.editorconfig =
    { ... }:
    {
      editorconfig = {
        enable = true;
        settings = {
          "*" = {
            indent_style = "space";
            indent_size = 4;
          };
          "*.nix".indent_size = 2;
          "*.{c,js,ts,json,yaml,html,css}".indent_size = 2;
        };
      };
    };

  flake.nixosModules.editorconfig =
    { ... }:
    {
      home-manager.sharedModules = [ self.homeModules.editorconfig ];
    };
}
