# Utils — system monitors, file managers, CLI utilities, secrets.
{self, ...}: {
  flake.nixosModules.utils = {pkgs, ...}: {
    imports = [
      self.nixosModules.btop
      self.nixosModules.trivy
      self.nixosModules.yazi
      self.nixosModules.bitwarden
      self.nixosModules.nautilus
    ];

    environment.systemPackages = [pkgs.nvtopPackages.amd];

    home-manager.sharedModules = [self.homeModules.utils];
  };

  flake.homeModules.utils = {...}: {
    programs = {
      fastfetch.enable = true;
      bat.enable = true;
      fd.enable = true;
      ripgrep.enable = true;
      jq.enable = true;
    };
  };
}
