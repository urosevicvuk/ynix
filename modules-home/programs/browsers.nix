# Zen is a minimalistic web browser.
{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.helium-browser.packages."${pkgs.system}".default
    inputs.zen-browser.packages."${pkgs.system}".default
  ];
}
