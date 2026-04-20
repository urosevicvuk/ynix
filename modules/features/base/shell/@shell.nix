{self, ...}: {
  flake.nixosModules.shell = {...}: {
    imports = [
      self.nixosModules.zsh
      self.nixosModules.starship
      self.nixosModules.tmux
      self.nixosModules.nushell
      self.nixosModules.eza
      self.nixosModules.fzf
      self.nixosModules.zoxide
      self.nixosModules.nixIndex
      self.nixosModules.television
    ];
  };
}
