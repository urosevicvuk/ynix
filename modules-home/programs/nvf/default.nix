# nvf - Neovim configuration
{ inputs, ... }:
{
  imports = [
    inputs.nvf.homeManagerModules.default

    ./core.nix       # Options, globals, general keymaps
    ./editor.nix     # Motion, surround, undo
    ./ui.nix         # Theme, statusline, visuals, mini, snacks
    ./navigation.nix # File explorer, fuzzy finder, marks, buffers
    ./coding.nix     # LSP, treesitter, languages, completion, diagnostics, formatting
    ./devel.nix      # DAP, testing, refactoring
    ./git.nix        # Git integration
    ./ai.nix         # Supermaven, OpenCode, Avante, 99
    ./session.nix    # Projects, sessions
  ];

  programs.nvf.enable = true;
}
