# Development tool packages shared across all dev hosts
{
  flake.homeModules.dev-utils = {pkgs, ...}: {
    home.packages = with pkgs; [
      gh

      #goat for api testing
      bruno

      #some obscure editors i don't really use
      zed-editor
      code-cursor
      vscode
    ];
  };
}
