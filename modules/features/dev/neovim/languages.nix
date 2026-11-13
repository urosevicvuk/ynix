# Language support. nvf wires LSP + treesitter + formatters per language.
# format.enable turns on conform with each language's dedicated formatter
# (stylua, black, prettier, alejandra, gofmt, ...) for manual <leader>cf;
# auto-format on save stays off (vim.lsp.formatOnSave = false in lsp.nix).
# yaml/helm have no nvf formatter, so they're enable-only.
# Protobuf has no nvf module - it's handled in lsp.nix (protols + grammar).
{self, ...}: {
  flake.homeModules.neovim = {...}: let
    luaInline = expr: {
      _type = "lua-inline";
      inherit expr;
    };
  in {
    programs.nvf.settings.vim.languages = {
      enableFormat = true;
      enableTreesitter = true;

      # Compiled / systems (DAP-enabled).
      go = {
        enable = true;
        format.enable = true;
        dap.enable = true;
      };
      rust = {
        enable = true;
        format.enable = true;
        dap.enable = true;
      };
      clang = {
        enable = true;
        format.enable = true;
        dap.enable = true;
      };
      python = {
        enable = true;
        format.enable = true;
        dap.enable = true;
      };
      haskell = {
        enable = true;
        format.enable = true;
      };

      # Scripting.
      lua = {
        enable = true;
        format.enable = true;
      };
      bash = {
        enable = true;
        format.enable = true;
      };
      sql = {
        enable = true;
        format.enable = true;
      };

      # Config / markup.
      nix = {
        enable = true;
        format.enable = true;
      };
      yaml.enable = true; # no nvf formatter
      json = {
        enable = true;
        format.enable = true;
      };
      toml = {
        enable = true;
        format.enable = true;
      };
      markdown = {
        enable = true;
        format.enable = true;
        extensions.markview-nvim = {
          enable = true;
          # markview also claims typst/quarto/rmd/asciidoc by default; its typst
          # renderer is rough (garbled code blocks). Typst is edited raw and
          # viewed in zathura / the browser preview instead.
          setupOpts.preview.filetypes = ["markdown"];
        };
      };
      # Typst: tinymist (LSP + lint) and typstyle (<leader>cf). Output is viewed
      # in zathura (live PDF, see tinymist settings below) or the browser
      # (typst-preview.nvim). Buffer-local <leader>t keymaps are set further down.
      typst = {
        enable = true;
        lsp.enable = true;
        format.enable = true;
        extensions.typst-preview-nvim.enable = true;
      };

      # Web.
      typescript = {
        enable = true;
        format.enable = true;
      };
      html = {
        enable = true;
        format.enable = true;
      };
      css = {
        enable = true;
        format.enable = true;
      };

      # DevOps / infra.
      docker = {
        enable = true;
        format.enable = true;
      };
      terraform = {
        enable = true;
        format.enable = true;
      };
      hcl = {
        enable = true;
        format.enable = true;
      };
      helm.enable = true; # no nvf formatter

      # CS / tooling.
      tex = {
        enable = true;
        format.enable = true;
      };
      cmake = {
        enable = true;
        format.enable = true;
      };
      make = {
        enable = true;
        format.enable = true;
      };
    };

    # tinymist (settings are read flat, not under a "tinymist" key):
    # - exportPdf onType writes <file>.pdf next to the source on every edit;
    #   zathura watches the file and reloads, so it works as a live preview.
    # - lint: tinymist's built-in checks, on top of compiler diagnostics.
    programs.nvf.settings.vim.lsp.servers.tinymist.settings = {
      exportPdf = "onType";
      lint.enabled = true;
    };

    programs.nvf.settings.vim.augroups = [
      {
        enable = true;
        name = "typst_buffer";
        clear = true;
      }
    ];

    # Typst buffers: soft-wrapped prose + a buffer-local <leader>t group.
    programs.nvf.settings.vim.autocmds = [
      {
        enable = true;
        event = ["FileType"];
        pattern = ["typst"];
        group = "typst_buffer";
        desc = "Typst buffer options and keymaps";
        callback = luaInline ''
          function(args)
            local buf = args.buf
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true

            local function map(lhs, rhs, desc)
              vim.keymap.set("n", lhs, rhs, { buffer = buf, silent = true, desc = desc })
            end

            -- Export once via tinymist, then open the PDF in zathura (detached).
            -- Zathura reloads on its own afterwards (exportPdf = onType).
            local function open_in_zathura()
              local client = vim.lsp.get_clients({ bufnr = buf, name = "tinymist" })[1]
              if not client then
                return vim.notify("tinymist is not attached", vim.log.levels.WARN)
              end
              local src = vim.api.nvim_buf_get_name(buf)
              client:exec_cmd({
                title = "Export PDF",
                command = "tinymist.exportPdf",
                arguments = { src },
              }, { bufnr = buf }, function(err, res)
                vim.schedule(function()
                  if err then
                    return vim.notify("Export failed: " .. err.message, vim.log.levels.ERROR)
                  end
                  local pdf = type(res) == "string" and res
                    or (type(res) == "table" and res.path)
                    or src:gsub("%.typ$", ".pdf")
                  if vim.fn.jobstart({ "zathura", pdf }, { detach = true }) <= 0 then
                    vim.notify("Could not start zathura", vim.log.levels.ERROR)
                  end
                end)
              end)
            end

            map("<leader>tp", "<cmd>TypstPreviewToggle<cr>", "Browser preview")
            map("<leader>tf", "<cmd>TypstPreviewFollowCursorToggle<cr>", "Preview follows cursor")
            map("<leader>tz", open_in_zathura, "Open PDF in zathura")
            map("<leader>te", "<cmd>LspTinymistExportPdf<cr>", "Export PDF")

            local ok, wk = pcall(require, "which-key")
            if ok then
              wk.add({ { "<leader>t", group = "typst", buffer = buf } })
            end
          end
        '';
      }
    ];
  };
}
