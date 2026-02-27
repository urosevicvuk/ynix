# AI assistance - Supermaven, OpenCode, Avante, 99
{
  programs.nvf.settings.vim = {
    # Supermaven - AI completion
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
}
