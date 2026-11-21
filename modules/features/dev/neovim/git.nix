{self, ...}: {
  flake.homeModules.neovim = {pkgs, ...}: {
    programs.nvf.settings.vim = {
      git.gitsigns.enable = true;
      utility.diffview-nvim.enable = true;

      extraPackages = [pkgs.lazygit];
    };
  };
}
