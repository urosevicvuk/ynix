# Git: gitsigns (signs/hunks/blame), diffview, and lazygit (via Snacks.lazygit).
{self, ...}: {
  flake.homeModules.neovim = {pkgs, ...}: {
    programs.nvf.settings.vim = {
      git.gitsigns.enable = true;
      utility.diffview-nvim.enable = true;

      # Snacks.lazygit() needs the lazygit binary on PATH.
      extraPackages = [pkgs.lazygit];
    };
  };
}
