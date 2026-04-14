# Zen and Helium browsers
{ inputs, ... }:
{
  flake.modules.homeManager.programs = [
    (
      {
        pkgs,
        inputs,
        ...
      }:
      {
        home.packages = [
          inputs.helium-browser.packages.${pkgs.system}.default
          inputs.zen-browser.packages.${pkgs.system}.default
        ];
      }
    )
  ];
}
