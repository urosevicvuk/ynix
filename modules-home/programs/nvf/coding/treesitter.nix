# Treesitter - Syntax highlighting and parsing
{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    treesitter = {
      enable = true;
      autotagHtml = true;
      fold = true;
      context = {
        enable = true;
        setupOpts = {
          enable = true;
          line_numbers = true;
          max_lines = 3;
          min_window_height = 20;
          multiline_threshold = 1;
          trim_scope = "outer";
          mode = "cursor";
        };
      };
      highlight.enable = true;
    };

    # NOTE: Treesitter textobjects is not natively supported by nvf yet.
    # nvf manages treesitter internally and doesn't expose nvim-treesitter.configs module.
    # For text objects, use mini.ai which is already configured in ui/mini.nix
    #
    # Reference: https://github.com/NotAShelf/nvf/discussions/439
    #
    # Uncomment below when nvf adds native textobjects support or if a workaround is found:
    #
    # startPlugins = with pkgs.vimPlugins; [
    #   nvim-treesitter-textobjects
    # ];
    #
    # luaConfigRC.treesitter-textobjects = ''
    #   vim.schedule(function()
    #     local ok, ts_configs = pcall(require, 'nvim-treesitter.configs')
    #     if not ok then
    #       return
    #     end
    #     ts_configs.setup({
    #       textobjects = {
    #         select = {
    #           enable = true,
    #           lookahead = true,
    #           keymaps = {
    #             ["aF"] = "@function.outer",
    #             ["iF"] = "@function.inner",
    #             ["aC"] = "@class.outer",
    #             ["iC"] = "@class.inner",
    #             ["aI"] = "@conditional.outer",
    #             ["iI"] = "@conditional.inner",
    #             ["aL"] = "@loop.outer",
    #             ["iL"] = "@loop.inner",
    #             ["aA"] = "@parameter.outer",
    #             ["iA"] = "@parameter.inner",
    #           },
    #         },
    #         move = {
    #           enable = true,
    #           set_jumps = true,
    #           goto_next_start = {
    #             ["]m"] = "@function.outer",
    #             ["]k"] = "@class.outer",
    #             ["]p"] = "@parameter.inner",
    #           },
    #           goto_next_end = {
    #             ["]M"] = "@function.outer",
    #             ["]K"] = "@class.outer",
    #             ["]P"] = "@parameter.inner",
    #           },
    #           goto_previous_start = {
    #             ["[m"] = "@function.outer",
    #             ["[k"] = "@class.outer",
    #             ["[p"] = "@parameter.inner",
    #           },
    #           goto_previous_end = {
    #             ["[M"] = "@function.outer",
    #             ["[K"] = "@class.outer",
    #             ["[P"] = "@parameter.inner",
    #           },
    #         },
    #         swap = {
    #           enable = true,
    #           swap_next = {
    #             [">p"] = "@parameter.inner",
    #           },
    #           swap_previous = {
    #             ["<p"] = "@parameter.inner",
    #           },
    #         },
    #       },
    #     })
    #   end)
    # '';
  };
}
