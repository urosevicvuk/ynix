# Coding - LSP, treesitter, languages, completion, diagnostics, formatting
{ ... }:
{
  flake.homeManagerModules.nvim = { lib, ... }: {
        programs.nvf.settings.vim = {
          utility.direnv.enable = true;

          lsp = {
            enable = true;
            trouble.enable = true;
            lspconfig.enable = true;
            formatOnSave = true;
            inlayHints.enable = true;
            lspkind.enable = true;

            otter-nvim = {
              enable = true;
              setupOpts = {
                buffers.set_filetype = true;
                lsp.diagnostic_update_event = [
                  "BufWritePost"
                  "InsertLeave"
                ];
              };
            };

            lspsaga = {
              enable = true;
              setupOpts = {
                ui.code_action = "";
                lightbulb = {
                  sign = false;
                  virtual_text = true;
                };
                breadcrumbs.enable = false;
              };
            };
          };

          treesitter = {
            enable = true;
            fold = true;
            highlight.enable = true;
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
          };

          languages = {
            enableFormat = true;
            enableTreesitter = true;
            enableDAP = true;

            go.enable = true;
            java.enable = true;
            kotlin.enable = true;
            rust = {
              enable = true;
              extensions.crates-nvim.enable = true;
            };
            astro.enable = true;
            ts = {
              enable = true;
              extensions.ts-error-translator.enable = true;
            };
            sql.enable = true;
            python.enable = true;
            clang.enable = true;
            css.enable = true;
            tailwind.enable = true;
            svelte.enable = true;
            bash.enable = true;
            nix.enable = true;
            yaml.enable = true;
            markdown = {
              enable = true;
              extensions.render-markdown-nvim.enable = true;
              extraDiagnostics.enable = true;
            };
          };

          autocomplete.blink-cmp = {
            enable = true;
            friendly-snippets.enable = true;
            mappings = {
              next = "<C-n>";
              previous = "<C-p>";
              confirm = "<C-y>";
            };
            setupOpts = {
              signature.enabled = true;
              completion = {
                menu = {
                  border = "rounded";
                  draw.columns = [
                    [ "kind_icon" ]
                    [
                      "label"
                      "label_description"
                    ]
                    [ "source_name" ]
                  ];
                };
                documentation.window.border = "rounded";
              };
            };
          };

          snippets.luasnip.enable = true;

          diagnostics = {
            enable = true;
            config = {
              signs.text = {
                "vim.diagnostic.severity.Error" = " ";
                "vim.diagnostic.severity.Warn" = " ";
                "vim.diagnostic.severity.Hint" = " ";
                "vim.diagnostic.severity.Info" = " ";
              };
              underline = true;
              update_in_insert = true;
              virtual_text.format = lib.generators.mkLuaInline ''
                function(diagnostic)
                  return string.format("%s", diagnostic.message)
                end
              '';
            };
          };

          formatter.conform-nvim = {
            enable = true;
            setupOpts.formatters_by_ft = {
              nix = [ "nixfmt" ];
              c = [ "clang-format" ];
              cpp = [ "clang-format" ];
              go = [
                "goimports"
                "gofmt"
              ];
              rust = [ "rustfmt" ];
              python = [ "black" ];
              javascript = [ "prettier" ];
              typescript = [ "prettier" ];
              javascriptreact = [ "prettier" ];
              typescriptreact = [ "prettier" ];
              json = [ "prettier" ];
              jsonc = [ "prettier" ];
              yaml = [ "prettier" ];
              markdown = [ "prettier" ];
              html = [ "prettier" ];
              css = [ "prettier" ];
              scss = [ "prettier" ];
              sh = [ "shfmt" ];
              bash = [ "shfmt" ];
              lua = [ "stylua" ];
            };
          };

          keymaps = [
            {
              key = "K";
              mode = "n";
              silent = true;
              action = "<cmd>lua vim.lsp.buf.hover()<cr>";
              desc = "LSP Hover";
            }
            {
              key = "<M-CR>";
              mode = [
                "n"
                "v"
              ];
              silent = true;
              action = "<cmd>Lspsaga code_action<cr>";
              desc = "Code Actions";
            }
            {
              key = "<C-s>";
              mode = "i";
              silent = true;
              action = "<cmd>lua vim.lsp.buf.signature_help()<cr>";
              desc = "Signature Help";
            }
            {
              key = "<leader>rn";
              mode = "n";
              silent = true;
              action = "<cmd>lua vim.lsp.buf.rename()<cr>";
              desc = "LSP Rename";
            }
            {
              key = "<leader>cf";
              mode = [
                "n"
                "v"
              ];
              silent = true;
              action = "<cmd>lua vim.lsp.buf.format({ async = true })<cr>";
              desc = "Format Buffer/Selection";
            }

            {
              key = "]e";
              mode = "n";
              silent = true;
              action = "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<cr>";
              desc = "Next Error";
            }
            {
              key = "[e";
              mode = "n";
              silent = true;
              action = "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<cr>";
              desc = "Previous Error";
            }
            {
              key = "]w";
              mode = "n";
              silent = true;
              action = "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.WARN})<cr>";
              desc = "Next Warning";
            }
            {
              key = "[w";
              mode = "n";
              silent = true;
              action = "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.WARN})<cr>";
              desc = "Previous Warning";
            }

            {
              key = "gd";
              mode = "n";
              silent = true;
              action = "<cmd>lua Snacks.picker.lsp_definitions()<cr>";
              desc = "Go to definition";
            }
            {
              key = "gD";
              mode = "n";
              silent = true;
              action = "<cmd>lua Snacks.picker.lsp_declarations()<cr>";
              desc = "Go to declaration";
            }
            {
              key = "gr";
              mode = "n";
              silent = true;
              action = "<cmd>lua Snacks.picker.lsp_references()<cr>";
              desc = "Find references";
            }
            {
              key = "gI";
              mode = "n";
              silent = true;
              action = "<cmd>lua Snacks.picker.lsp_implementations()<cr>";
              desc = "Go to implementation";
            }
            {
              key = "gy";
              mode = "n";
              silent = true;
              action = "<cmd>lua Snacks.picker.lsp_type_definitions()<cr>";
              desc = "Go to type definition";
            }

            {
              key = "<leader>xx";
              mode = "n";
              silent = true;
              action = "<cmd>Trouble diagnostics toggle<cr>";
              desc = "Toggle Trouble";
            }
            {
              key = "<leader>xd";
              mode = "n";
              silent = true;
              action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
              desc = "Document Diagnostics";
            }
            {
              key = "<leader>xw";
              mode = "n";
              silent = true;
              action = "<cmd>Trouble diagnostics toggle<cr>";
              desc = "Workspace Diagnostics";
            }
            {
              key = "<leader>xq";
              mode = "n";
              silent = true;
              action = "<cmd>Trouble qflist toggle<cr>";
              desc = "Quickfix List";
            }
            {
              key = "<leader>xl";
              mode = "n";
              silent = true;
              action = "<cmd>Trouble loclist toggle<cr>";
              desc = "Location List";
            }
          ];
        };
  };
}
