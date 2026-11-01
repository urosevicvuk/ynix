# Rex terminal multiplexer, from the superlogical snapshot channel
{
  self,
  inputs,
  ...
}: {
  # Self-registers into the `shell` group (merged with the other shell modules).
  flake.nixosModules.shell.imports = [self.nixosModules.rex];

  flake.nixosModules.rex = {...}: {
    home-manager.sharedModules = [self.homeModules.rex];
  };

  flake.homeModules.rex = {...}: {
    imports = [inputs.rex.homeModules.default];

    # Installs rex, the xterm-rex terminfo and the ssh TERM guard
    # (the guard needs programs.ssh.enable, set in features/system/ssh.nix).
    programs.rex.enable = true;

    # Persistent personal server as a systemd user unit. Off: any `rex`
    # command auto-spawns one that exits ~10s after its last session closes.
    # On: survives logout (with `loginctl enable-linger`), allows Tailscale
    # access, but a rebuild that bumps rex restarts it and ends sessions.
    services.rex.enable = true;
  };
}
