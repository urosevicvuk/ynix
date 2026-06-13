# Git: gitsigns (signs/hunks/blame), diffview, and lazygit (via Snacks.lazygit).
{self, ...}: {
  flake.nixosModules.nvf-git = {...}: {
    home-manager.sharedModules = [self.homeModules.nvf-git];
  };

  flake.homeModules.nvf-git = {pkgs, ...}: {
    programs.nvf.settings.vim = {
      git.gitsigns.enable = true;
      utility.diffview-nvim.enable = true;

      # Snacks.lazygit() needs the lazygit binary on PATH.
      extraPackages = [pkgs.lazygit];
    };
  };
}
