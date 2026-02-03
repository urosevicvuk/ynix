# Development tools - DAP, testing, refactoring
{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    startPlugins = with pkgs.vimPlugins; [
      # DAP
      nvim-dap-ui
      nvim-dap-virtual-text
      # Testing
      neotest
      neotest-plenary
      neotest-go
      neotest-rust
      neotest-python
      neotest-jest
      # Refactoring
      refactoring-nvim
    ];

    # DAP UI
    luaConfigRC.dap-ui = ''
      require("dapui").setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
      })

      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    '';

    luaConfigRC.dap-virtual-text = ''
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        virt_text_pos = 'eol',
      })
    '';

    # Neotest
    luaConfigRC.neotest = ''
      require("neotest").setup({
        adapters = {
          require("neotest-plenary"),
          require("neotest-go"),
          require("neotest-rust"),
          require("neotest-python")({ dap = { justMyCode = false } }),
          require("neotest-jest")({
            jestCommand = "npm test --",
            env = { CI = true },
            cwd = function(path) return vim.fn.getcwd() end,
          }),
        },
        floating = { border = "rounded", max_height = 0.6, max_width = 0.6 },
      })
    '';

    # Refactoring
    luaConfigRC.refactoring = ''
      require('refactoring').setup({})
    '';

    keymaps = [
      # DAP UI
      { key = "<leader>du"; mode = "n"; silent = true; action = "<cmd>lua require('dapui').toggle()<CR>"; desc = "Toggle DAP UI"; }

      # Breakpoints
      { key = "<leader>db"; mode = "n"; silent = true; action = "<cmd>lua require('dap').toggle_breakpoint()<CR>"; desc = "Toggle Breakpoint"; }
      { key = "<leader>dB"; mode = "n"; silent = true; action = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>"; desc = "Conditional Breakpoint"; }
      { key = "<leader>dL"; mode = "n"; silent = true; action = "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>"; desc = "Log Point"; }

      # Debug control
      { key = "<leader>dc"; mode = "n"; silent = true; action = "<cmd>lua require('dap').continue()<CR>"; desc = "Continue"; }
      { key = "<leader>dC"; mode = "n"; silent = true; action = "<cmd>lua require('dap').run_to_cursor()<CR>"; desc = "Run to Cursor"; }
      { key = "<leader>dg"; mode = "n"; silent = true; action = "<cmd>lua require('dap').goto_()<CR>"; desc = "Go to Line (no execute)"; }

      # Step controls
      { key = "<leader>di"; mode = "n"; silent = true; action = "<cmd>lua require('dap').step_into()<CR>"; desc = "Step Into"; }
      { key = "<leader>do"; mode = "n"; silent = true; action = "<cmd>lua require('dap').step_out()<CR>"; desc = "Step Out"; }
      { key = "<leader>dO"; mode = "n"; silent = true; action = "<cmd>lua require('dap').step_over()<CR>"; desc = "Step Over"; }
      { key = "<leader>dj"; mode = "n"; silent = true; action = "<cmd>lua require('dap').down()<CR>"; desc = "Down Stack Frame"; }
      { key = "<leader>dk"; mode = "n"; silent = true; action = "<cmd>lua require('dap').up()<CR>"; desc = "Up Stack Frame"; }

      # Session control
      { key = "<leader>dp"; mode = "n"; silent = true; action = "<cmd>lua require('dap').pause()<CR>"; desc = "Pause"; }
      { key = "<leader>dr"; mode = "n"; silent = true; action = "<cmd>lua require('dap').repl.toggle()<CR>"; desc = "Toggle REPL"; }
      { key = "<leader>ds"; mode = "n"; silent = true; action = "<cmd>lua require('dap').session()<CR>"; desc = "Session Info"; }
      { key = "<leader>dt"; mode = "n"; silent = true; action = "<cmd>lua require('dap').terminate()<CR>"; desc = "Terminate Debug Session"; }
      { key = "<leader>dw"; mode = "n"; silent = true; action = "<cmd>lua require('dap.ui.widgets').hover()<CR>"; desc = "Debug Hover"; }

      # Testing
      { key = "<leader>tr"; mode = "n"; silent = true; action = "<cmd>lua require('neotest').run.run()<CR>"; desc = "Run Nearest Test"; }
      { key = "<leader>tf"; mode = "n"; silent = true; action = "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>"; desc = "Run File Tests"; }
      { key = "<leader>ts"; mode = "n"; silent = true; action = "<cmd>lua require('neotest').summary.toggle()<CR>"; desc = "Toggle Test Summary"; }
      { key = "<leader>to"; mode = "n"; silent = true; action = "<cmd>lua require('neotest').output.open({ enter = true })<CR>"; desc = "Show Test Output"; }

      # Refactoring
      { key = "<leader>re"; mode = [ "x" "n" ]; silent = true; action = "<cmd>lua require('refactoring').refactor('Extract Function')<CR>"; desc = "Extract Function"; }
      { key = "<leader>rf"; mode = [ "x" "n" ]; silent = true; action = "<cmd>lua require('refactoring').refactor('Extract Function To File')<CR>"; desc = "Extract Function To File"; }
      { key = "<leader>rv"; mode = [ "x" "n" ]; silent = true; action = "<cmd>lua require('refactoring').refactor('Extract Variable')<CR>"; desc = "Extract Variable"; }
      { key = "<leader>ri"; mode = "n"; silent = true; action = "<cmd>lua require('refactoring').refactor('Inline Variable')<CR>"; desc = "Inline Variable"; }
    ];
  };
}
