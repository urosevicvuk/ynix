# Scripts group — all files in this directory share homeModules.desktop.
# The group file wires the merged namespace into sharedModules.
{self, ...}: {
  flake.nixosModules.scripts = {...}: {
    home-manager.sharedModules = [self.homeModules.desktop];
  };
}
