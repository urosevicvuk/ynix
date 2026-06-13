# Apps group — user-facing applications, organised by purpose.
# Import the whole group, or pick individual sub-groups (browsers, comms,
# media, notes, utils) for finer-grained hosts.
{self, ...}: {
  flake.nixosModules.apps = {...}: {
    imports = [
      self.nixosModules.browsers
      self.nixosModules.comms
      self.nixosModules.media
      self.nixosModules.notes
      self.nixosModules.utils
    ];
  };
}
