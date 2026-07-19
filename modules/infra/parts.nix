{inputs, ...}: {
  # Import home-manager flake-parts module - this provides the native flake.homeModules namespace
  imports = [inputs.home-manager.flakeModules.home-manager];

  # Systems declaration (moved from flake.nix)
  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];
}
