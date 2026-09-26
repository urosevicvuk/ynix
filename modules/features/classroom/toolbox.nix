{self, ...}: {
  # Self-registers into the `classroom` group (merged with the other classroom modules).
  flake.nixosModules.classroom.imports = [self.nixosModules.classroom-toolbox];

  # The rule for this list: if it would not be on a stock Ubuntu server, or if it
  # teaches a habit that does not transfer off this VM, it does not go in.
  # That is why there is no nushell, starship, eza, zoxide, atuin or nvf here
  # even though the rest of this flake is full of them.
  flake.nixosModules.classroom-toolbox = {pkgs, ...}: {
    users.defaultUserShell = pkgs.bash;

    environment.systemPackages = with pkgs; [
      # editors: the two they will actually find on a server
      vim
      nano

      # text and files
      less
      tree
      file
      which
      gnugrep
      gnused
      gawk
      diffutils
      findutils
      ripgrep

      # archives
      gnutar
      gzip
      xz
      zip
      unzip

      # processes and system
      htop
      procps
      psmisc
      lsof
      strace
      sysstat

      # network
      curl
      wget
      iproute2
      iputils
      dnsutils
      socat
      netcat-gnu
      tcpdump
      rsync
      openssh

      # multiplexing: essential once they are juggling kubectl panes
      tmux
    ];

    documentation = {
      enable = true;
      man.enable = true;
      # Off by default, and without it `man -k` / `apropos` silently return
      # nothing, which is exactly when a student gives up and opens a browser.
      # Costs a few minutes of build time.
      man.cache.enable = true;
      nixos.enable = false;
      info.enable = false;
      doc.enable = false;
    };

    # Broken under flakes without a channel; every typo would otherwise produce
    # a confusing Nix error instead of a plain "command not found".
    programs.command-not-found.enable = false;

    # A deliberately boring prompt. They should recognise it on any server.
    programs.bash.promptInit = ''
      PS1='\u@\h:\w\$ '
    '';
  };
}
