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
        self.nixosModules.classroom-host
        (nixpkgsModule formatModule)
        {nixpkgs.hostPlatform = "x86_64-linux";}
        extra
      ];
    };
in {
  flake.nixosConfigurations = {
    # Primary handout. An OVA is one double-clickable file that carries the CPU
    # and RAM settings with it -- which matters here, because a student who
    # hand-creates a VM with 1 vCPU and 1 GB will watch k3s OOM and you will
    # spend the lecture debugging it. VirtualBox imports it natively; VMware
    # Workstation/Fusion imports it after one "Retry with relaxed OVF
    # specification" click.
    classroom-ova = mkImage "virtualisation/virtualbox-image.nix" {
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
    classroom-vmdk = mkImage "virtualisation/vmware-image.nix" {
      virtualisation.diskSize = 40 * 1024;
      vmware.vmDerivationName = "devops-lab-vmdk";
      image.baseName = "devops-lab";
    };
  };

  perSystem = {system, ...}:
    lib.optionalAttrs (system == "x86_64-linux") {
      packages = {
        classroom-ova = self.nixosConfigurations.classroom-ova.config.system.build.virtualBoxOVA;
        classroom-vmdk = self.nixosConfigurations.classroom-vmdk.config.system.build.vmwareImage;
      };
    };
}
