{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];

  # `nix fmt` formats the whole tree, and `nix flake check` fails on anything
  # left unformatted.
  perSystem.treefmt = {
    projectRootFile = "flake.nix";

    programs = {
      alejandra.enable = true;
      deadnix.enable = true; # unused nix bindings
      ruff-format.enable = true;
      # Lints too: fixable findings get fixed by `nix fmt`, and the rest fail
      # `nix flake check`.
      ruff-check.enable = true;
    };
  };
}
