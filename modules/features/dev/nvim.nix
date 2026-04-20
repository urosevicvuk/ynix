# nvf - Neovim configuration (merged)
{
  inputs,
  self,
  ...
}: {
  flake.homeModules.nvim = {
    lib,
    pkgs,
    ...
  }: {
    imports = [inputs.nvf.homeManagerModules.default];

    programs.nvf.enable = true;

    programs.nvf.settings.vim = {
      # === Core ===
      viAlias = false;
      vimAlias = true;
      withNodeJs = true;
      syntaxHighlighting = true;

      options = {
        autoindent = true;
        smartindent = true;
        foldlevel = 99;
        foldcolumn = "auto:1";
        mousescroll = "ver:1,hor:1";
        mousemoveevent = true;
        fillchars = "eob:‿,fold: ,foldopen:▼,foldsep:⸽,foldclose:⏵";
        signcolumn = "yes";
        wrap = false;
        scrolloff = 9;
      };

      clipboard = {
        enable = true;
        registers = "unnamedplus";
        providers.wl-copy.enable = true;
      };

      globals = {
        mapleader = " ";
        navic_silence = true;
        suda_smart_edit = 1;
        neovide_scale_factor = 0.7;
        neovide_cursor_animation_length = 0.1;
        neovide_cursor_short_animation_length = 0;
        # Git blame
        gitblame_enabled = false;
        gitblame_message_template = "<author> • <date> • <summary>";
        gitblame_date_format = "%r";
        gitblame_display_virtual_text = true;
      };

      binds.whichKey = {
        enable = true;
        register = {
          "<leader>b" = "+buffer";
          "<leader>c" = "+code";
          "<leader>d" = "+debug";
          "<leader>f" = "+find/file";
          "<leader>g" = "+git";
          "<leader>m" = "+marks";
          "<leader>o" = "+opencode";
          "<leader>q" = "+quit";
          "<leader>r" = "+refactor";
          "<leader>s" = "+session";
          "<leader>t" = "+test";
          "<leader>u" = "+ui/toggle";
          "<leader>w" = "+window";
          "<leader>x" = "+trouble/diagnostics";
          "<leader>9" = "+99 AI";
        };
      };

      # === UI ===
      theme = {
        enable = true;
        name = lib.mkForce "gruvbox";
        style = lib.mkForce "dark";
        transparent = lib.mkForce true;
      };

      statusline.lualine = {
        enable = true;
        theme = lib.mkForce "gruvbox_dark";
      };

      dashboard.alpha.enable = true;

      ui.noice.enable = true;
      ui.borders.enable = true;
      ui.fastaction.enable = true;
      ui.colorizer.enable = true;

      visuals = {
        rainbow-delimiters.enable = true;
        nvim-scrollbar.enable = false;
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = true;
        highlight-undo.enable = true;
        cinnamon-nvim.enable = true;
        fidget-nvim.enable = true;
        indent-blankline.enable = true;
      };

      mini = {
        starter.enable = true;
        comment.enable = true;
        cursorword.enable = true;
        icons.enable = true;
        indentscope.enable = true;
        notify.enable = true;
        pairs.enable = true;
        diff.enable = true;
        git.enable = true;
        ai.enable = true;
        splitjoin.enable = true;
        bracketed.enable = true;
        move.enable = true;
        align.enable = true;
        hipatterns.enable = true;
        trailspace.enable = true;
      };

      utility.snacks-nvim = {
        enable = true;
        setupOpts = {
          image.enabled = true;
          quickfile.enabled = true;
          statuscolumn.enabled = true;
          zen.enabled = true;
          bufdelete.enabled = true;
          input.enabled = true;
          terminal.enabled = true;
          picker.enabled = true;
          explorer.enabled = true;
          gitsigns.enabled = true;
        };
      };

      # === Editor ===
      utility.motion.flash-nvim.enable = true;

      # === Coding ===
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
                ["kind_icon"]
                [
                  "label"
                  "label_description"
                ]
                ["source_name"]
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
          nix = ["nixfmt"];
          c = ["clang-format"];
          cpp = ["clang-format"];
          go = [
            "goimports"
            "gofmt"
          ];
          rust = ["rustfmt"];
          python = ["black"];
          javascript = ["prettier"];
          typescript = ["prettier"];
          javascriptreact = ["prettier"];
          typescriptreact = ["prettier"];
          json = ["prettier"];
          jsonc = ["prettier"];
          yaml = ["prettier"];
          markdown = ["prettier"];
          html = ["prettier"];
          css = ["prettier"];
          scss = ["prettier"];
          sh = ["shfmt"];
          bash = ["shfmt"];
          lua = ["stylua"];
        };
      };

      # === AI ===
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

      # === Session ===
      projects.project-nvim.enable = true;

      # === Git ===
      terminal.toggleterm = {
        enable = true;
        lazygit = {
          enable = true;
          mappings.open = "<leader>gl";
        };
      };

      # === Navigation ===
      utility.yazi-nvim = {
        enable = true;
        mappings = {
          openYazi = "<leader>-";
          openYaziDir = "<leader>=";
        };
      };
      utility.oil-nvim.enable = true;

      navigation.harpoon = {
        enable = true;
        mappings = {
          markFile = "<leader>m";
          listMarks = "<leader>\`";
          file1 = "<leader>1";
          file2 = "<leader>2";
          file3 = "<leader>3";
          file4 = "<leader>4";
        };
      };

      utility.outline.aerial-nvim.enable = true;

      # === Plugins ===
      startPlugins = with pkgs.vimPlugins; [
        nvim-surround
        undotree
        vim-highlightedyank
        opencode-nvim
        persistence-nvim
        git-blame-nvim
        vim-tmux-navigator
      ];

      # === Lua config ===
      luaConfigRC.nvim-surround = ''
        require("nvim-surround").setup({})
      '';

      luaConfigRC.rainbow-delimiters-config = ''
        local rainbow_delimiters = require('rainbow-delimiters')
        vim.g.rainbow_delimiters = {
          strategy = { [""] = rainbow_delimiters.strategy['global'] },
          query = { [""] = 'rainbow-delimiters' },
          highlight = { 'RainbowDelimiterGray' },
        }
        vim.api.nvim_set_hl(0, 'RainbowDelimiterGray', { fg = '#928374' })
      '';

      luaConfigRC.highlightedyank = ''
        vim.g.highlightedyank_highlight_duration = 200
      '';

      luaConfigRC.persistence = ''
        require("persistence").setup({
          dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
          options = { "buffers", "curdir", "tabpages", "winsize" },
        })
      '';

      # === Keymaps ===
      keymaps = [
        # Core
        {
          key = "<leader>w";
          mode = "n";
          silent = true;
          action = ":w<CR>";
          desc = "Save";
        }
        {
          key = "<leader>q";
          mode = "n";
          silent = true;
          action = ":q<CR>";
          desc = "Quit";
        }
        {
          key = "<leader>r";
          mode = "n";
          silent = true;
          action = ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>";
          desc = "Refactor word under cursor";
        }
        {
          key = "Q";
          mode = "n";
          silent = true;
          action = "<nop>";
          desc = "Disable Q";
        }
        {
          key = "p";
          mode = "x";
          silent = true;
          action = "\"_dP";
          desc = "Paste and keep selection";
        }
        {
          key = "N";
          mode = "n";
          silent = true;
          action = "Nzzzv";
          desc = "Previous search result";
        }
        {
          key = "n";
          mode = "n";
          silent = true;
          action = "nzzzv";
          desc = "Next search result";
        }
        {
          key = "<C-u>";
          mode = "n";
          silent = true;
          action = "<C-u>zz";
          desc = "Scroll up";
        }
        {
          key = "<C-d>";
          mode = "n";
          silent = true;
          action = "<C-d>zz";
          desc = "Scroll down";
        }
        {
          key = "J";
          mode = "n";
          silent = true;
          action = "mzJ`z";
          desc = "Join lines";
        }
        {
          key = "J";
          mode = "v";
          silent = true;
          action = ":m '>+1<cr>gv=gv";
          desc = "Move selected lines down";
        }
        {
          key = "K";
          mode = "v";
          silent = true;
          action = ":m '<-2<cr>gv=gv";
          desc = "Move selected lines up";
        }
        {
          key = "L";
          mode = "v";
          silent = true;
          action = "$";
          desc = "Go all the way right";
        }
        {
          key = "H";
          mode = "v";
          silent = true;
          action = "^";
          desc = "Go all the way left";
        }
        {
          key = "L";
          mode = "n";
          silent = true;
          action = "$";
          desc = "Go all the way right";
        }
        {
          key = "H";
          mode = "n";
          silent = true;
          action = "^";
          desc = "Go all the way left";
        }
        {
          key = "<C-tab>";
          mode = "n";
          silent = true;
          action = "<cmd>bnext<cr>";
          desc = "Next Buffer";
        }
        {
          key = "<C-S-tab>";
          mode = "n";
          silent = true;
          action = "<cmd>bprev<cr>";
          desc = "Previous Buffer";
        }
        {
          key = "<Up>";
          mode = "n";
          silent = true;
          action = "<Nop>";
          desc = "Disable Up Arrow";
        }
        {
          key = "<Down>";
          mode = "n";
          silent = true;
          action = "<Nop>";
          desc = "Disable Down Arrow";
        }
        {
          key = "<Left>";
          mode = "n";
          silent = true;
          action = "<Nop>";
          desc = "Disable Left Arrow";
        }
        {
          key = "<Right>";
          mode = "n";
          silent = true;
          action = "<Nop>";
          desc = "Disable Right Arrow";
        }
        {
          key = "<leader><BS>";
          mode = "n";
          silent = true;
          action = "<cmd>nohlsearch<cr>";
          desc = "Reset search";
        }
        {
          key = "<leader>uw";
          mode = "n";
          silent = true;
          action = "<cmd>set wrap!<cr>";
          desc = "Toggle word wrapping";
        }
        {
          key = "<leader>ul";
          mode = "n";
          silent = true;
          action = "<cmd>set linebreak!<cr>";
          desc = "Toggle linebreak";
        }
        {
          key = "<leader>us";
          mode = "n";
          silent = true;
          action = "<cmd>set spell!<cr>";
          desc = "Toggle spellcheck";
        }
        {
          key = "<leader>uc";
          mode = "n";
          silent = true;
          action = "<cmd>set cursorline!<cr>";
          desc = "Toggle cursorline";
        }
        {
          key = "<leader>un";
          mode = "n";
          silent = true;
          action = "<cmd>set number!<cr>";
          desc = "Toggle line numbers";
        }
        {
          key = "<leader>ur";
          mode = "n";
          silent = true;
          action = "<cmd>set relativenumber!<cr>";
          desc = "Toggle relative line numbers";
        }
        {
          key = "<leader>ut";
          mode = "n";
          silent = true;
          action = "<cmd>set showtabline=2<cr>";
          desc = "Show tabline";
        }
        {
          key = "<leader>uT";
          mode = "n";
          silent = true;
          action = "<cmd>set showtabline=0<cr>";
          desc = "Hide tabline";
        }
        {
          key = "<leader>ws";
          mode = "n";
          silent = true;
          action = "<cmd>split<cr>";
          desc = "Split";
        }
        {
          key = "<leader>wv";
          mode = "n";
          silent = true;
          action = "<cmd>vsplit<cr>";
          desc = "VSplit";
        }
        {
          key = "<leader>wd";
          mode = "n";
          silent = true;
          action = "<cmd>close<cr>";
          desc = "Close";
        }

        # Editor
        {
          key = "s";
          mode = "n";
          silent = true;
          action = "<cmd>lua require('flash').jump()<cr>";
          desc = "Flash";
        }
        {
          key = "<leader>u";
          mode = "n";
          silent = true;
          action = "<cmd>UndotreeToggle<CR>";
          desc = "Toggle Undotree";
        }

        # Coding - LSP
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

        # Session
        {
          key = "<leader>sr";
          mode = "n";
          silent = true;
          action = "<cmd>lua require('persistence').load()<cr>";
          desc = "Restore Session";
        }
        {
          key = "<leader>sl";
          mode = "n";
          silent = true;
          action = "<cmd>lua require('persistence').load({ last = true })<cr>";
          desc = "Restore Last Session";
        }
        {
          key = "<leader>sd";
          mode = "n";
          silent = true;
          action = "<cmd>lua require('persistence').stop()<cr>";
          desc = "Don't Save Current Session";
        }

        # Git
        {
          key = "<leader>gB";
          mode = "n";
          silent = true;
          action = "<cmd>GitBlameToggle<cr>";
          desc = "Toggle Git Blame";
        }
        {
          key = "<leader>gO";
          mode = "n";
          silent = true;
          action = "<cmd>GitBlameOpenCommitURL<cr>";
          desc = "Open Commit URL";
        }
        {
          key = "<leader>gC";
          mode = "n";
          silent = true;
          action = "<cmd>GitBlameCopySHA<cr>";
          desc = "Copy Commit SHA";
        }
        {
          key = "<leader>gF";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.git_files()<cr>";
          desc = "Git files";
        }
        {
          key = "<leader>gb";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.git_branches()<cr>";
          desc = "Git branches";
        }
        {
          key = "<leader>gL";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.git_log()<cr>";
          desc = "Git log";
        }
        {
          key = "<leader>gf";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.git_log_file()<cr>";
          desc = "Git log (current file)";
        }
        {
          key = "<leader>gS";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.git_stash()<cr>";
          desc = "Git stash";
        }
        {
          key = "<leader>gs";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.git_status()<cr>";
          desc = "Git status";
        }
        {
          key = "<leader>gd";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.git_diff()<cr>";
          desc = "Git diff";
        }

        # Navigation
        {
          key = "<leader><space>";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.files()<cr>";
          desc = "Find files (quick)";
        }
        {
          key = "<leader>/";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.grep()<cr>";
          desc = "Grep (quick)";
        }
        {
          key = "<leader>,";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.buffers()<cr>";
          desc = "Buffers (quick)";
        }
        {
          key = "<leader>:";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.command_history()<cr>";
          desc = "Command history";
        }
        {
          key = "<leader>e";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.explorer()<cr>";
          desc = "Explorer (quick)";
        }
        {
          key = "<leader>ff";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.files()<cr>";
          desc = "Find files";
        }
        {
          key = "<leader>fa";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.files({ hidden = true })<cr>";
          desc = "Find all files (including hidden)";
        }
        {
          key = "<leader>fb";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.buffers()<cr>";
          desc = "Find buffers";
        }
        {
          key = "<leader>fo";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.recent()<cr>";
          desc = "Recent files";
        }
        {
          key = "<leader>fe";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.explorer()<cr>";
          desc = "Snacks explorer";
        }
        {
          key = "<leader>fO";
          mode = "n";
          silent = true;
          action = "<cmd>lua require('oil').open_float()<cr>";
          desc = "Oil (buffer-based)";
        }
        {
          key = "-";
          mode = "n";
          silent = true;
          action = "<cmd>lua require('oil').open()<cr>";
          desc = "Open Oil in current window";
        }
        {
          key = "<leader>fw";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.grep()<cr>";
          desc = "Grep word";
        }
        {
          key = "<leader>fW";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.grep_word()<cr>";
          desc = "Grep word under cursor";
        }
        {
          key = "<leader>fl";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.lines()<cr>";
          desc = "Search lines in current buffer";
        }
        {
          key = "<leader>ft";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.todo_comments()<cr>";
          desc = "Find todos";
        }
        {
          key = "<leader>fc";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })<cr>";
          desc = "Find config files";
        }
        {
          key = "<leader>fp";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.projects()<cr>";
          desc = "Find projects";
        }
        {
          key = "<leader>fn";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.notifications()<cr>";
          desc = "Notification history";
        }
        {
          key = "<leader>fB";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.grep_buffers()<cr>";
          desc = "Grep in open buffers";
        }
        {
          key = "<leader>fu";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.undo()<cr>";
          desc = "Undo history";
        }
        {
          key = "<leader>fs";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.lsp_symbols()<cr>";
          desc = "LSP symbols (file)";
        }
        {
          key = "<leader>fS";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.lsp_workspace_symbols()<cr>";
          desc = "LSP symbols (workspace)";
        }
        {
          key = "<leader>bd";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.bufdelete()<cr>";
          desc = "Delete Buffer";
        }
        {
          key = "<leader>bD";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.bufdelete.all()<cr>";
          desc = "Delete All Buffers";
        }
        {
          key = "<leader>bo";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.bufdelete.other()<cr>";
          desc = "Delete Other Buffers";
        }
        {
          key = "<leader>bn";
          mode = "n";
          silent = true;
          action = "<cmd>bnext<cr>";
          desc = "Next Buffer";
        }
        {
          key = "<leader>bp";
          mode = "n";
          silent = true;
          action = "<cmd>bprevious<cr>";
          desc = "Previous Buffer";
        }
        {
          key = "<leader>bl";
          mode = "n";
          silent = true;
          action = "<cmd>blast<cr>";
          desc = "Last Buffer";
        }
        {
          key = "<leader>bf";
          mode = "n";
          silent = true;
          action = "<cmd>bfirst<cr>";
          desc = "First Buffer";
        }
      ];
    };
  };

  flake.nixosModules.nvim = {...}: {
    home-manager.sharedModules = [self.homeModules.nvim];
  };
}
