{self, ...}: {
  # Self-registers into the `classroom` group (merged with the other classroom modules).
  flake.nixosModules.classroom.imports = [self.nixosModules.classroom-devops];

  flake.nixosModules.classroom-devops = {pkgs, ...}: {
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

    environment.systemPackages = with pkgs; [
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
  };
}
