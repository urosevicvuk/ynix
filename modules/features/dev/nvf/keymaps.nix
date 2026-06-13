# All keymaps. The km/kmv/... helpers kill the mode/silent boilerplate so
# each binding is a single line.
{self, ...}: {
  flake.nixosModules.nvf-keymaps = {...}: {
    home-manager.sharedModules = [self.homeModules.nvf-keymaps];
  };

  flake.homeModules.nvf-keymaps = {...}: let
    mk = mode: key: action: desc: {inherit mode key action desc;};
    km = mk "n";
    kmv = mk "v";
    kmx = mk "x";
    kmi = mk "i";
    kmnv = mk ["n" "v"];
  in {
    programs.nvf.settings.vim.keymaps = [
      # === Core ===
      (km "<leader>w" "<cmd>w<cr>" "Save")
      (km "<leader>q" "<cmd>q<cr>" "Quit")
      (km "Q" "<nop>" "Disable Q")
      (kmx "p" "\"_dP" "Paste, keep yank")
      (km "n" "nzzzv" "Next search result (centered)")
      (km "N" "Nzzzv" "Prev search result (centered)")
      (km "<C-d>" "<C-d>zz" "Scroll down (centered)")
      (km "<C-u>" "<C-u>zz" "Scroll up (centered)")
      (km "J" "mzJ`z" "Join lines, keep cursor")
      (km "<leader><BS>" "<cmd>nohlsearch<cr>" "Clear search highlight")

      # Force hjkl: disable arrows in normal mode.
      (km "<Up>" "<Nop>" "Disable Up")
      (km "<Down>" "<Nop>" "Disable Down")
      (km "<Left>" "<Nop>" "Disable Left")
      (km "<Right>" "<Nop>" "Disable Right")

      # === UI toggles (<leader>u) ===
      (km "<leader>uu" "<cmd>UndotreeToggle<cr>" "Undotree")
      (km "<leader>uw" "<cmd>set wrap!<cr>" "Toggle wrap")
      (km "<leader>ul" "<cmd>set linebreak!<cr>" "Toggle linebreak")
      (km "<leader>us" "<cmd>set spell!<cr>" "Toggle spellcheck")
      (km "<leader>uc" "<cmd>set cursorline!<cr>" "Toggle cursorline")
      (km "<leader>un" "<cmd>set number!<cr>" "Toggle line numbers")
      (km "<leader>ur" "<cmd>set relativenumber!<cr>" "Toggle relative numbers")
      (km "<leader>ut" "<cmd>set showtabline=2<cr>" "Show tabline")
      (km "<leader>uT" "<cmd>set showtabline=0<cr>" "Hide tabline")

      # === Motion ===
      (km "s" "<cmd>lua require('flash').jump()<cr>" "Flash jump")
      (kmx "s" "<cmd>lua require('flash').jump()<cr>" "Flash jump")

      # === LSP / code ===
      (km "K" "<cmd>lua vim.lsp.buf.hover()<cr>" "Hover")
      (kmnv "<M-CR>" "<cmd>Lspsaga code_action<cr>" "Code actions")
      (kmi "<C-s>" "<cmd>lua vim.lsp.buf.signature_help()<cr>" "Signature help")
      (km "<leader>rn" "<cmd>lua vim.lsp.buf.rename()<cr>" "Rename")
      (kmnv "<leader>cf" "<cmd>lua require('conform').format({ async = true, lsp_format = 'fallback' })<cr>" "Format")
      (km "gd" "<cmd>lua Snacks.picker.lsp_definitions()<cr>" "Go to definition")
      (km "gD" "<cmd>lua Snacks.picker.lsp_declarations()<cr>" "Go to declaration")
      (km "gr" "<cmd>lua Snacks.picker.lsp_references()<cr>" "References")
      (km "gI" "<cmd>lua Snacks.picker.lsp_implementations()<cr>" "Implementations")
      (km "gy" "<cmd>lua Snacks.picker.lsp_type_definitions()<cr>" "Type definition")
      (km "]e" "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<cr>" "Next error")
      (km "[e" "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<cr>" "Prev error")
      (km "]w" "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.WARN})<cr>" "Next warning")
      (km "[w" "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.WARN})<cr>" "Prev warning")

      # Trouble
      (km "<leader>xx" "<cmd>Trouble diagnostics toggle<cr>" "Diagnostics (workspace)")
      (km "<leader>xd" "<cmd>Trouble diagnostics toggle filter.buf=0<cr>" "Diagnostics (document)")
      (km "<leader>xq" "<cmd>Trouble qflist toggle<cr>" "Quickfix list")
      (km "<leader>xl" "<cmd>Trouble loclist toggle<cr>" "Location list")

      # === Git ===
      (km "<leader>gg" "<cmd>lua Snacks.lazygit()<cr>" "Lazygit")
      (km "<leader>gv" "<cmd>DiffviewOpen<cr>" "Diffview")
      (km "<leader>gV" "<cmd>DiffviewFileHistory %<cr>" "File history")
      (km "<leader>gB" "<cmd>Gitsigns toggle_current_line_blame<cr>" "Toggle blame line")
      (km "<leader>ghs" "<cmd>Gitsigns stage_hunk<cr>" "Stage hunk")
      (km "<leader>ghr" "<cmd>Gitsigns reset_hunk<cr>" "Reset hunk")
      (km "<leader>ghp" "<cmd>Gitsigns preview_hunk<cr>" "Preview hunk")
      (km "<leader>ghb" "<cmd>lua require('gitsigns').blame_line({ full = true })<cr>" "Blame hunk")
      (km "<leader>gF" "<cmd>lua Snacks.picker.git_files()<cr>" "Git files")
      (km "<leader>gb" "<cmd>lua Snacks.picker.git_branches()<cr>" "Git branches")
      (km "<leader>gL" "<cmd>lua Snacks.picker.git_log()<cr>" "Git log")
      (km "<leader>gf" "<cmd>lua Snacks.picker.git_log_file()<cr>" "Git log (file)")
      (km "<leader>gS" "<cmd>lua Snacks.picker.git_stash()<cr>" "Git stash")
      (km "<leader>gs" "<cmd>lua Snacks.picker.git_status()<cr>" "Git status")
      (km "<leader>gd" "<cmd>lua Snacks.picker.git_diff()<cr>" "Git diff")

      # === Find / navigation (snacks) ===
      (km "<leader><space>" "<cmd>lua Snacks.picker.files()<cr>" "Find files")
      (km "<leader>/" "<cmd>lua Snacks.picker.grep()<cr>" "Grep")
      (km "<leader>," "<cmd>lua Snacks.picker.buffers()<cr>" "Buffers")
      (km "<leader>:" "<cmd>lua Snacks.picker.command_history()<cr>" "Command history")
      (km "<leader>e" "<cmd>lua Snacks.explorer()<cr>" "Explorer")
      (km "<leader>ff" "<cmd>lua Snacks.picker.files()<cr>" "Find files")
      (km "<leader>fa" "<cmd>lua Snacks.picker.files({ hidden = true })<cr>" "Find files (hidden)")
      (km "<leader>fb" "<cmd>lua Snacks.picker.buffers()<cr>" "Buffers")
      (km "<leader>fo" "<cmd>lua Snacks.picker.recent()<cr>" "Recent files")
      (km "<leader>fe" "<cmd>lua Snacks.explorer()<cr>" "Explorer")
      (km "<leader>fO" "<cmd>lua require('oil').open_float()<cr>" "Oil (float)")
      (km "-" "<cmd>lua require('oil').open()<cr>" "Oil (window)")
      (km "<leader>fw" "<cmd>lua Snacks.picker.grep()<cr>" "Grep")
      (km "<leader>fW" "<cmd>lua Snacks.picker.grep_word()<cr>" "Grep word under cursor")
      (km "<leader>fl" "<cmd>lua Snacks.picker.lines()<cr>" "Search buffer lines")
      (km "<leader>ft" "<cmd>lua Snacks.picker.todo_comments()<cr>" "Find todos")
      (km "<leader>fc" "<cmd>lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })<cr>" "Find config files")
      (km "<leader>fp" "<cmd>lua Snacks.picker.projects()<cr>" "Find projects")
      (km "<leader>fn" "<cmd>lua Snacks.picker.notifications()<cr>" "Notification history")
      (km "<leader>fB" "<cmd>lua Snacks.picker.grep_buffers()<cr>" "Grep open buffers")
      (km "<leader>fu" "<cmd>lua Snacks.picker.undo()<cr>" "Undo history")
      (km "<leader>fs" "<cmd>lua Snacks.picker.lsp_symbols()<cr>" "Symbols (file)")
      (km "<leader>fS" "<cmd>lua Snacks.picker.lsp_workspace_symbols()<cr>" "Symbols (workspace)")

      # === Buffers ===
      (km "<leader>bd" "<cmd>lua Snacks.bufdelete()<cr>" "Delete buffer")
      (km "<leader>bD" "<cmd>lua Snacks.bufdelete.all()<cr>" "Delete all buffers")
      (km "<leader>bo" "<cmd>lua Snacks.bufdelete.other()<cr>" "Delete other buffers")
      (km "<leader>bn" "<cmd>bnext<cr>" "Next buffer")
      (km "<leader>bp" "<cmd>bprevious<cr>" "Prev buffer")
      (km "<leader>bl" "<cmd>blast<cr>" "Last buffer")
      (km "<leader>bf" "<cmd>bfirst<cr>" "First buffer")
    ];
  };
}
