{ self, inputs, ... }:
{
  # Standalone home-manager configuration (for non-NixOS machines)
  flake.homeConfigurations.vyke = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      self.homeModules.base
      self.homeModules.desktop
      self.homeModules.dev
      self.homeModules.nvim
      {
        home.username = "vyke";
        home.homeDirectory = "/home/vyke";
        home.stateVersion = "24.05";
      }
    ];
  };
}
