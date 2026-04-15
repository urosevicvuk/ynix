# Development tool packages shared across all dev hosts
{
  flake.homeModules.dev = {pkgs, ...}: {
    home.packages = with pkgs; [
      claude-code
      gh
      bruno
      code-cursor
      zed-editor
      vscode

      jetbrains.goland
      jetbrains.idea
      jetbrains.datagrip
      jetbrains.webstorm
    ];
  };
}
