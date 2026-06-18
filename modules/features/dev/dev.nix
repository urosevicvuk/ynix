{self, ...}: {
  flake.nixosModules.dev = {...}: {
    imports = [
      # Editors
      self.nixosModules.neovim
      self.nixosModules.jetbrains
      self.nixosModules.zed-editor

      # Tools
      self.nixosModules.claude-code
      self.nixosModules.opencode
      self.nixosModules.editorconfig
      self.nixosModules.jj
      #self.nixosModules.radicle
      self.nixosModules.trivy

      # Containers
      self.nixosModules.docker
      self.nixosModules.kube
    ];
  };

  flake.homeModules.dev = {pkgs, ...}: {
    home.packages = with pkgs; [
      bruno
    ];
  };
}
