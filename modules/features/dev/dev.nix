{self, ...}: {
  flake.nixosModules.dev = {...}: {
    imports = [
      # Editors
      self.nixosModules.neovim
      self.nixosModules.cursor
      self.nixosModules.jetbrains
      self.nixosModules.zed-editor

      # AI
      self.nixosModules.claude-code
      self.nixosModules.opencode

      # Tools
      self.nixosModules.bruno
      self.nixosModules.editorconfig
      self.nixosModules.hunk
      #self.nixosModules.radicle
      self.nixosModules.trivy

      # Containers
      self.nixosModules.docker
      self.nixosModules.kube

      # VCS
      self.nixosModules.git
      self.nixosModules.jj

    ];
  };
}
