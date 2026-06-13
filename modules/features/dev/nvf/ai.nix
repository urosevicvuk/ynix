# AI: Supermaven inline completion (nvf-managed) + opencode agent bridge.
# opencode is not an nvf module, so it's a startPlugin configured in
# lua/opencode.lua (escape hatch); supermaven keeps Tab/Shift-Tab for inline.
{self, ...}: {
  flake.nixosModules.nvf-ai = {...}: {
    home-manager.sharedModules = [self.homeModules.nvf-ai];
  };

  flake.homeModules.nvf-ai = {pkgs, ...}: {
    programs.nvf.settings.vim = {
      startPlugins = [pkgs.vimPlugins.opencode-nvim];

      assistant.supermaven-nvim = {
        enable = true;
        setupOpts = {
          keymaps = {
            accept_suggestion = "<S-Tab>";
            accept_word = "<Tab>";
            clear_suggestion = "<M-c>";
          };
          disable_inline_completion = false;
          log_level = "info";
        };
      };
    };
  };
}
