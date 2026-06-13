# Terminal group — terminal emulators.
{self, ...}: {
  flake.nixosModules.terminal = {...}: {
    imports = [
      self.nixosModules.kitty
      self.nixosModules.ghostty
    ];
  };
}
