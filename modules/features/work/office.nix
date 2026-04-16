# Work / office software
{...}: {
  flake.homeModules.office = {pkgs, ...}: {
    home.packages = with pkgs; [
      libreoffice-fresh
      slack
    ];
  };
}
