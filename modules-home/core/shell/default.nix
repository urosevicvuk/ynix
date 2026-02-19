{
  imports = [
    ./fzf.nix
    ./zsh.nix
    ./starship.nix
    ./zoxide.nix
    ./tmux.nix
    ./eza.nix
    ./cli-tools.nix
  ];

  # Enable command-not-found for NixOS package suggestions
  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };
}
