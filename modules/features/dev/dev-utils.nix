# Development tool packages shared across all dev hosts
{self, ...}: {
  flake.nixosModules.dev-utils = {...}: {
    home-manager.sharedModules = [self.homeModules.dev-utils];
  };

  flake.homeModules.dev-utils = {pkgs, ...}: {
    home.packages = with pkgs; [
      #goat for api testing
      bruno

      #some obscure editors i don't really use
      code-cursor
      vscode
    ];
  };
}
