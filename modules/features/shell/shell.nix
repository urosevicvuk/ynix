{self, ...}: {
  flake.nixosModules.shell = {...}: {
    imports = [
      # Shells
      self.nixosModules.bash
      self.nixosModules.zsh
      self.nixosModules.nushell

      # Tools
      self.nixosModules.atuin
      self.nixosModules.carapace
      self.nixosModules.cli
      self.nixosModules.eza
      self.nixosModules.fzf
      self.nixosModules.sesh
      self.nixosModules.starship
      self.nixosModules.television
      self.nixosModules.tmux
      self.nixosModules.zoxide
    ];
  };
}
