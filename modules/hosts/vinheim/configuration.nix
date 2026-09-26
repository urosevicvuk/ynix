# vinheim -- the DevOps (RAF) lab VM.
#
# A plain NixOS box students SSH into during class: the tools they need, docker,
# and a `student` account. Nothing clever. Images are built with nixpkgs' own
# `system.build.images` (the upstream replacement for nixos-generators, retired
# since 25.05), so there are no extra flake inputs.
#
# Outputs:
#   nixosConfigurations.vinheim / vinheim-aarch64
#   packages.x86_64-linux.vinheim-ova        VirtualBox appliance for the lab
#   packages.aarch64-linux.vinheim-qcow2     UTM image for Apple Silicon
#   devShells.<system>.devops                same tools, no VM
#
# Fixing the VM mid-semester, from inside the VM:
#   sudo nixos-rebuild switch --flake github:urosevicvuk/ynix#vinheim
{
  self,
  inputs,
  lib,
  ...
}: let
  # The VM tracks nixpkgs *stable*, frozen by flake.lock for the semester, while
  # the rest of ynix rides unstable. Handouts must not go stale mid-course.
  stable = inputs.nixpkgs-stable;

  mkSystem = system:
    stable.lib.nixosSystem {
      modules = [
        self.nixosModules.vinheim
        {nixpkgs.hostPlatform = system;}
      ];
    };

  # One list, used by the VM and the devShell, so the versions can't drift.
  # Rule: if it wouldn't be on a stock Ubuntu server, or it teaches a habit that
  # doesn't transfer off this VM, it doesn't go in.
  tools = pkgs:
    with pkgs; [
      # V1 -- terminal
      git
      gh
      nano
      vim
      tmux
      htop
      tree
      curl
      wget
      jq
      yq-go
      ripgrep
      iproute2
      dnsutils

      # V2-V3 -- Go and CI. gcc because cgo is on by default, so `go build` of
      # anything importing net (i.e. glasnik) fails without a C compiler.
      go
      gcc
      gnumake
      golangci-lint

      # V4-V7 -- containers. The docker CLI already ships compose and buildx as
      # plugins, so `docker compose` works without adding anything.
      dive
      trivy
      oha

      # V8-V10 -- Kubernetes
      kind
      kubectl
      kubernetes-helm
      k9s
      hurl

      # V11-V12 -- optional topics
      argocd
    ];
in {
  flake.nixosModules.vinheim = {
    pkgs,
    lib,
    ...
  }: {
    system.stateVersion = "26.05";
    nixpkgs.config.allowUnfree = true;

    networking.hostName = "vinheim";
    time.timeZone = "Europe/Belgrade";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "us";

    nix.settings.experimental-features = ["nix-command" "flakes"];

    # Off on purpose: a disposable single-user lab behind VM NAT, and the
    # syllabus is git/CI/docker/k8s, not iptables. Leaving it on turns every
    # NodePort exercise into a firewall debugging session.
    networking.firewall.enable = false;

    # --- getting in ---------------------------------------------------------
    # SSH from the host terminal is the way in (copy-paste works, several
    # terminals at once, and it's how they'll meet a real server). The
    # autologin console is the fallback.
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
      };
    };

    services.getty.autologinUser = "student";

    users.mutableUsers = false;
    users.defaultUserShell = pkgs.bash;
    users.users.root.hashedPassword = "!"; # no root login, use sudo

    users.users.student = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker"];
      # Plaintext on purpose: world-readable in the Nix store is irrelevant for
      # a throwaway lab image, and it saves thirty students a detour on minute
      # one. Passwordless sudo for the same reason.
      password = "student";
    };
    security.sudo.wheelNeedsPassword = false;

    users.motd = ''
      DevOps lab -- student / student, passwordless sudo

        ssh from your host:  ssh -p 2222 student@localhost
        kind cluster:        kind create cluster --config /etc/devops/kind.yaml
        work in ~/work; materials are on the course Drive

      This VM is disposable -- your GitHub repo is the source of truth.
    '';

    # --- docker -------------------------------------------------------------
    virtualisation.docker = {
      enable = true;
      # No background prune: an image vanishing mid-exercise is a confusing
      # failure to debug in front of a class.
      autoPrune.enable = false;
      daemon.settings = {
        # The whole lab leaves through one IP, and Docker Hub rate-limits
        # anonymous pulls per IP. The mirror takes most of that pressure off.
        registry-mirrors = ["https://mirror.gcr.io"];
        # NixOS defaults to journald; json-file is what a stock server uses (and
        # what `docker logs` docs assume). The opts below are json-file's, and
        # dockerd refuses to start if they're set on journald.
        log-driver = "json-file";
        log-opts = {
          max-size = "10m";
          max-file = "3";
        };
      };
    };

    # kind's control plane opens a lot of watches; the defaults give a confusing
    # "too many open files" instead of a working cluster.
    boot.kernel.sysctl = {
      "fs.inotify.max_user_watches" = 524288;
      "fs.inotify.max_user_instances" = 512;
    };

    # kind needs these forwarded into the VM for NodePorts to be reachable from
    # the host browser; the OVA's NAT rules below carry them the rest of the way.
    environment.etc."devops/kind.yaml".text = ''
      kind: Cluster
      apiVersion: kind.x-k8s.io/v1alpha4
      name: devops
      nodes:
        - role: control-plane
          extraPortMappings:
            - { containerPort: 30080, hostPort: 30080 }  # app
            - { containerPort: 30300, hostPort: 30300 }  # Grafana
            - { containerPort: 30900, hostPort: 30900 }  # Prometheus
            - { containerPort: 30930, hostPort: 30930 }  # Alertmanager
            - { containerPort: 30443, hostPort: 30443 }  # Argo CD
    '';

    # --- tools and shell ----------------------------------------------------
    environment.systemPackages = tools pkgs;

    environment.variables = {
      EDITOR = "nano";
      KUBE_EDITOR = "nano";
    };

    programs.git = {
      enable = true;
      # Name and email they set themselves on V2.
      config.init.defaultBranch = "main";
    };

    programs.bash = {
      completion.enable = true;
      interactiveShellInit = ''
        source <(kubectl completion bash)
        source <(helm completion bash)
        source <(gh completion -s bash)
        alias k=kubectl
        complete -o default -F __start_kubectl k
      '';
    };

    # Without the cache `man -k` silently returns nothing, which is exactly when
    # a student gives up and opens a browser.
    documentation.man.cache.enable = true;

    # Broken under flakes without a channel; every typo would otherwise produce
    # a confusing Nix error instead of "command not found".
    programs.command-not-found.enable = false;

    systemd.tmpfiles.rules = ["d /home/student/work 0755 student users -"];

    # --- images -------------------------------------------------------------
    # The disk and bootloader, as defaults -- each image variant sets its own,
    # and a plain definition beats mkDefault. Having them here is what lets the
    # bare configuration evaluate, which is what `nixos-rebuild switch` uses
    # from inside a booted VM.
    fileSystems."/" = lib.mkDefault {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };
    boot.growPartition = lib.mkDefault true;
    boot.loader.grub = {
      enable = lib.mkDefault true;
      device = lib.mkDefault "/dev/sda";
    };

    image.modules = {
      virtualbox = {
        image.baseName = "devops-lab";
        virtualisation.diskSize = "auto";
        virtualbox = {
          vmName = "DevOps Lab";
          vmDerivationName = "devops-lab-ova";
          # 4 GB is enough through V10; the V11 handout says to raise it.
          memorySize = 4096;
          # ~25 GB total, not the 40 GB in the course doc: measured on this
          # closure, the store-to-ext4 copy takes ~6 min at 24 GB of free space
          # and then falls off a cliff (at 35 GB it spun for an hour without
          # finishing). Students who need more run
          # `VBoxManage modifyhd ... --resize 40960` and reboot -- growPartition
          # and autoResize above pick it up.
          baseImageFreeSpace = 20 * 1024;
          params = {
            cpus = 2;
            # So a double-clicked appliance already answers on localhost, with
            # no VBoxManage step for the student. VBoxManage takes one --natpf1
            # per rule and the OVF export carries them.
            natpf1 = [
              "ssh,tcp,,2222,,22"
              "app,tcp,,8080,,8080"
              "app-nodeport,tcp,,30080,,30080"
              "grafana,tcp,,30300,,30300"
              "prometheus,tcp,,30900,,30900"
              "alertmanager,tcp,,30930,,30930"
              "argocd,tcp,,30443,,30443"
            ];
          };
        };
      };

      # UTM on Apple Silicon: a bare qcow2, so the student creates the VM, picks
      # RAM and forwards the ports themselves.
      qemu-efi = {
        image.baseName = "devops-lab";
        virtualisation.diskSize = 25 * 1024;
        # This one boots via systemd-boot off the ESP.
        boot.loader.grub.enable = false;
        swapDevices = [
          {
            device = "/var/swap";
            size = 2048;
          }
        ];
      };
    };
  };

  flake.nixosConfigurations = {
    vinheim = mkSystem "x86_64-linux";
    vinheim-aarch64 = mkSystem "aarch64-linux";
  };

  perSystem = {system, ...}: let
    pkgs = import stable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    packages =
      lib.optionalAttrs (system == "x86_64-linux") {
        vinheim-ova = self.nixosConfigurations.vinheim.config.system.build.images.virtualbox;
      }
      // lib.optionalAttrs (system == "aarch64-linux") {
        vinheim-qcow2 = self.nixosConfigurations.vinheim-aarch64.config.system.build.images.qemu-efi;
      };

    # For students on their own Linux or Mac. Allowed, but unsupported in class:
    # the handouts assume the VM.
    devShells.devops = pkgs.mkShell {packages = tools pkgs;};
  };
}
