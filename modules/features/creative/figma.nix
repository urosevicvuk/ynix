{...}: {
  flake.homeModules.figma = {pkgs, ...}: {
    home.packages = with pkgs; [
      figma-linux
    ];
  };
}
