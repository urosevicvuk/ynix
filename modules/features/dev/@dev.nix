{self, ...}: {
  flake.nixosModules.dev = {...}: {
    imports = [
      self.nixosModules.claude-code
      self.nixosModules.docker
      self.nixosModules.editorconfig
      self.nixosModules.jetbrains
      self.nixosModules.kube
      self.nixosModules.neovim
      #self.nixosModules.radicle
      self.nixosModules.opencode
      self.nixosModules.zed-editor
    ];
  };

  flake.homeModules.dev = {pkgs, ...}: {
    home.packages = with pkgs; [
      bruno
    ];
  };
}
