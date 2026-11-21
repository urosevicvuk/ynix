{
  self,
  inputs,
  lib,
  ...
}: let
  stable = inputs.nixpkgs-stable;

  mkSystem = system:
    stable.lib.nixosSystem {
      modules = [
        self.nixosModules.vinheim
        {nixpkgs.hostPlatform = system;}
      ];
    };

  tools = pkgs:
    with pkgs; [
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

      go
      gcc
      gnumake
      golangci-lint

      dive
      trivy
      oha

      kind
      kubectl
      kubernetes-helm
      k9s
      hurl

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

    networking.firewall.enable = false;

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
    users.users.root.hashedPassword = "!";

    users.users.student = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker"];
      password = "student";
    };
    security.sudo.wheelNeedsPassword = false;

    users.motd = ''
      DevOps lab -- student / student, passwordless sudo

        ssh from your host:  ssh -p 2222 student@localhost   (VirtualBox)
                             ssh student@<vm-ip>             (UTM, see `ip -4 addr`)
        kind cluster:        kind create cluster --config /etc/devops/kind.yaml
        work in ~/work; materials are on the course Drive

      This VM is disposable -- your GitHub repo is the source of truth.
    '';

    virtualisation.docker = {
      enable = true;
      autoPrune.enable = false;
      daemon.settings = {
        registry-mirrors = ["https://mirror.gcr.io"];
        log-driver = "json-file";
        log-opts = {
          max-size = "10m";
          max-file = "3";
        };
      };
    };

    boot.kernel.sysctl = {
      "fs.inotify.max_user_watches" = 524288;
      "fs.inotify.max_user_instances" = 512;
    };

    boot.blacklistedKernelModules = ["vmwgfx" "vboxguest" "vboxsf"];

    boot.kernelParams = ["nox2apic" "rcupdate.rcu_normal=1"];

    environment.etc."devops/certs.d/docker.io/hosts.toml" = {
      mode = "0444";
      text = ''
        server = "https://registry-1.docker.io"

        [host."https://mirror.gcr.io"]
          capabilities = ["pull", "resolve"]
      '';
    };

    environment.etc."devops/kind.yaml".text = ''
      kind: Cluster
      apiVersion: kind.x-k8s.io/v1alpha4
      name: devops
      nodes:
        - role: control-plane
          extraMounts:
            - hostPath: /etc/devops/certs.d
              containerPath: /etc/containerd/certs.d
              readOnly: true
          extraPortMappings:
            - { containerPort: 30080, hostPort: 30080 }
            - { containerPort: 30300, hostPort: 30300 }
            - { containerPort: 30900, hostPort: 30900 }
            - { containerPort: 30930, hostPort: 30930 }
            - { containerPort: 30443, hostPort: 30443 }
    '';

    environment.systemPackages = tools pkgs;

    environment.variables = {
      EDITOR = "nano";
      KUBE_EDITOR = "nano";
    };

    programs.git = {
      enable = true;
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

    documentation.man.cache.enable = true;

    programs.command-not-found.enable = false;

    systemd.tmpfiles.rules = ["d /home/student/work 0755 student users -"];

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
    swapDevices = lib.mkDefault [
      {
        device = "/var/swap";
        size = 2048;
      }
    ];
    virtualisation.virtualbox.guest.enable = lib.mkForce false;

    image.modules = {
      virtualbox = {
        image.baseName = "devops-x86_64";
        virtualisation.diskSize = "auto";
        virtualbox = {
          vmName = "DevOps Lab";
          vmDerivationName = "devops-lab-ova";
          memorySize = 4096;
          baseImageFreeSpace = 20 * 1024;
          params = {
            cpus = 2;
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

      qemu-efi = {
        image.baseName = "devops-aarch64";
        virtualisation.diskSize = 25 * 1024;
        boot.loader.grub.enable = false;
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

    devShells.devops = pkgs.mkShell {packages = tools pkgs;};
  };
}
