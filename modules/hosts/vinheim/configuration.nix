{
  self,
  inputs,
  lib,
  ...
}: let
  nixpkgsModule = path: "${inputs.nixpkgs}/nixos/modules/${path}";

  mkImage = formatModule: extra:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        self.nixosModules.vinheim
        (nixpkgsModule formatModule)
        {nixpkgs.hostPlatform = "x86_64-linux";}
        extra
      ];
    };
in {
  # The classroom image host, whole. Everything it needs lives in this one file:
  # none of it is worth sharing, and this host deliberately shares NOTHING with
  # the `system` group -- that group carries a personal SSH key, tailnet
  # hostnames, an X server and a browser, none of which belong in an image
  # handed to thirty students.
  flake.nixosModules.vinheim = {
    pkgs,
    lib,
    ...
  }: {
    system.stateVersion = "26.05";

    nixpkgs.config.allowUnfree = true;

    nix = {
      channel.enable = false;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true;
      };
      # Students never rebuild this image, and a GC timer firing mid-lecture is
      # pure downside.
      gc.automatic = false;
    };

    time.timeZone = "Europe/Belgrade";
    i18n.defaultLocale = "en_US.UTF-8";

    networking = {
      hostName = "vinheim";
      # Plain DHCP. NetworkManager is wifi/desktop machinery a NAT'd VM does not
      # need, and `ip`/`ss` are what they will meet on a real server anyway.
      useDHCP = lib.mkDefault true;
      networkmanager.enable = false;
      # Off on purpose: this is a disposable single-user lab behind VM NAT, and
      # the syllabus is git/CI/docker/k8s, not iptables. Leaving it on turns
      # every NodePort exercise into a firewall debugging session.
      firewall.enable = false;
    };

    # --- console ---
    # No graphical stack is imported anywhere in this host, so boot lands on
    # tty1 and stays there. That is the whole point of the image.

    services.getty = {
      autologinUser = "student";
      greetingLine = ""; # drop the "<<< Welcome to NixOS >>>" banner
      helpLine = ""; # drop the docs/manual hint
    };

    # Black screen: no bootloader menu, no kernel spew, no systemd unit list.
    boot = {
      tmp.cleanOnBoot = true;
      loader.timeout = 0;
      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "loglevel=3"
        "udev.log_level=3"
        "systemd.show_status=false"
        "rd.systemd.show_status=false"
      ];
    };

    console = {
      earlySetup = true;
      # The default 8x16 console font is unreadable past the third row of a
      # lecture hall. Terminus at 24px is the difference between students
      # following along and students asking what is on screen.
      packages = [pkgs.terminus_font];
      font = "ter-v24n";
      keyMap = "us";
    };

    # --- the lab account ---
    # Declarative accounts only: every student's VM is byte-identical, and a
    # reboot undoes whatever they broke.
    users.mutableUsers = false;

    users.defaultUserShell = pkgs.bash;

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

    # --- docker + kubernetes ---
    virtualisation.docker = {
      enable = true;
      # No background prune: an image vanishing mid-exercise is a confusing
      # failure to debug in front of a class.
      autoPrune.enable = false;
    };

    # k3s over kind/minikube: one binary, a real NixOS module, and roughly a
    # gigabyte idle instead of a docker-in-docker node per control-plane role.
    # Note this means two container runtimes are live at once (dockerd +
    # containerd) -- budget RAM accordingly. The old `services.k3s.docker`
    # option that merged them is removed in current nixpkgs.
    services.k3s = {
      enable = true;
      role = "server";

      # The single most important line in this file. Thirty students each
      # cold-pulling the control-plane images over lecture-hall wifi does not
      # work. This bakes pause/coredns/traefik/metrics-server/local-path into
      # containerd at build time, so the cluster comes up offline.
      images = [pkgs.k3s.airgap-images];

      # Default kubeconfig is root-only, which would force `sudo kubectl` all
      # lecture and teach the wrong reflex.
      extraFlags = ["--write-kubeconfig-mode=0644"];
    };

    environment.variables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";

    # --- the toolbox ---
    # The rule for this list: if it would not be on a stock Ubuntu server, or if
    # it teaches a habit that does not transfer off this VM, it does not go in.
    # That is why there is no nushell, starship, eza, zoxide, atuin or nvf here
    # even though the rest of this flake is full of them.
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

      # git + forge
      git
      gh

      # containers
      docker-compose

      # kubernetes
      kubectl
      kubernetes-helm
      kubectx
      k9s

      # CI: lets them run a GitHub Actions workflow locally when the network or
      # GitHub is having a bad day.
      act

      # data wrangling for manifests and API responses
      jq
      yq-go
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

  # --- build artifacts ---
  flake.nixosConfigurations = {
    # Primary handout. An OVA is one double-clickable file that carries the CPU
    # and RAM settings with it -- which matters here, because a student who
    # hand-creates a VM with 1 vCPU and 1 GB will watch k3s OOM and you will
    # spend the lecture debugging it. VirtualBox imports it natively; VMware
    # Workstation/Fusion imports it after one "Retry with relaxed OVF
    # specification" click.
    vinheim-ova = mkImage "virtualisation/virtualbox-image.nix" {
      virtualbox = {
        vmName = "DevOps Lab";
        vmDerivationName = "devops-lab-ova";
        memorySize = 6144;
        params.cpus = 2;
        # docker images + k3s + whatever they build. OVA ships sparse, so this
        # costs far less than 40G on the wire.
        baseImageFreeSpace = 40 * 1024;
      };
      image.baseName = "devops-lab";
    };

    # Native VMware path, for anyone who hits OVF import trouble. Produces a
    # bare .vmdk with no VM settings, so the student must create the VM and
    # attach the existing disk themselves -- and pick their own RAM.
    vinheim-vmdk = mkImage "virtualisation/vmware-image.nix" {
      virtualisation.diskSize = 40 * 1024;
      vmware.vmDerivationName = "devops-lab-vmdk";
      image.baseName = "devops-lab";
    };
  };

  perSystem = {system, ...}:
    lib.optionalAttrs (system == "x86_64-linux") {
      packages = {
        vinheim-ova = self.nixosConfigurations.vinheim-ova.config.system.build.virtualBoxOVA;
        vinheim-vmdk = self.nixosConfigurations.vinheim-vmdk.config.system.build.vmwareImage;
      };
    };
}
