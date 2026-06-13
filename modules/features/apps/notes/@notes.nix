# Notes — note-taking / knowledge base.
{self, ...}: {
  flake.nixosModules.notes = {...}: {
    imports = [
      self.nixosModules.obsidian
    ];
  };
}
