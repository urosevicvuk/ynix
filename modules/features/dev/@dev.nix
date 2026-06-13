{self, ...}: {
  flake.nixosModules.dev = {...}: {
    imports = [
      self.nixosModules.claude-code
      self.nixosModules.docker
      self.nixosModules.editorconfig
      self.nixosModules.kube
      #self.nixosModules.radicle
      self.nixosModules.opencode
    ];
  };

  flake.homeModules.dev = {pkgs, ...}: {
    home.packages = with pkgs; [
      bruno
    ];
  };
}
