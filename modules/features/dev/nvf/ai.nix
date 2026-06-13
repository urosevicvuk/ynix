# AI: Supermaven inline completion (Tab/Shift-Tab).
{self, ...}: {
  flake.nixosModules.nvf-ai = {...}: {
    home-manager.sharedModules = [self.homeModules.nvf-ai];
  };

  flake.homeModules.nvf-ai = {...}: {
    programs.nvf.settings.vim = {
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
