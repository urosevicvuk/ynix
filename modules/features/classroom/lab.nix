{self, ...}: {
  # Self-registers into the `classroom` group (merged with the other classroom modules).
  flake.nixosModules.classroom.imports = [self.nixosModules.classroom-lab];

  flake.nixosModules.classroom-lab = {...}: {
    # Declarative accounts only: every student's VM is byte-identical, and a
    # reboot undoes whatever they broke.
    users.mutableUsers = false;

    users.users.student = {
      isNormalUser = true;
      description = "DevOps course student";
      extraGroups = [
        "wheel" # sudo
        "docker"
      ];
      # Plaintext on purpose. This lands world-readable in the Nix store, which
      # is irrelevant for a throwaway lab image and saves thirty students a
      # password-hashing detour on minute one.
      password = "student";
    };

    users.users.root.hashedPassword = "!"; # root login disabled; use sudo

    # Keep the password prompt. Typing `sudo` and being challenged is a reflex
    # worth building before they touch a real server.
    security.sudo.wheelNeedsPassword = true;

    # A raw VMware/VirtualBox text console has no clipboard and no scrollback,
    # which is brutal once kubectl commands and YAML get long. sshd lets them
    # work from their host terminal instead, and practising ssh is on-syllabus.
    services.openssh = {
      enable = true;
      settings = {
        # No key distribution logistics for a one-off lab.
        PasswordAuthentication = true;
        PermitRootLogin = "no";
      };
    };

    users.motd = ''
      DevOps lab

        user/pass   student / student
        ssh in      run `ip -4 -br addr`, then from your host terminal:
                    ssh student@<that address>
        cluster     k3s, already running -- try: kubectl get nodes
        docker      already running     -- try: docker ps

      This machine is disposable. Reboot resets it.
    '';
  };
}
