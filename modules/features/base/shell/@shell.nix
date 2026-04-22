{self, ...}: {
  flake.nixosModules.shell = {...}: {
    imports = [
      self.nixosModules.atuin
      self.nixosModules.carapace
      self.nixosModules.fzf
      self.nixosModules.nushell
      self.nixosModules.sesh
      self.nixosModules.starship
      self.nixosModules.television
      self.nixosModules.tmux
      self.nixosModules.zoxide
      self.nixosModules.zsh
    ];
  };
}
