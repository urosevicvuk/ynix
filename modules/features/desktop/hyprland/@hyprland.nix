# Hyprland group — enable.nix declares nixosModules.hyprland (system-level),
# while animations.nix, bindings.nix, settings.nix share homeModules.hyprland.
# The group wires the merged homeModules.hyprland into sharedModules.
{
  self,
  ...
}:
{
  flake.nixosModules.hyprland =
    { ... }:
    {
      home-manager.sharedModules = [ self.homeModules.hyprland ];
    };
}
