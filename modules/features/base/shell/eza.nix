{
  self,
  ...
}:
{
  flake.homeModules.eza =
    { ... }:
    {
      programs.eza = {
        enable = true;
        icons = "auto";
        extraOptions = [
          "--group-directories-first"
          "--no-quotes"
          "--git-ignore"
          "--icons=always"
        ];
      };
    };

  flake.nixosModules.eza =
    { ... }:
    {
      home-manager.sharedModules = [ self.homeModules.eza ];
    };
}
