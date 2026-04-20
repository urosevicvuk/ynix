{
  self,
  inputs,
  ...
}: {
  flake.homeModules.sops = {
    config,
    pkgs,
    ...
  }: {
    imports = [inputs.sops-nix.homeManagerModules.sops];

    home.packages = with pkgs; [
      sops
      age
      ssh-to-age
    ];

    # Declaratively manage .sops.yaml
    home.file."${config.home.homeDirectory}/code/ynix/.sops.yaml".text = ''
      creation_rules:
        - path_regex: secrets/shared/.*\.yaml$
          key_groups:
            - age:
                - age18nfkzf6c32fnysaeuh64ryqj5dhm8j5f84rl50dc6yuevl87v9esn7nzqu
        - path_regex: secrets/ariandel/.*\.yaml$
          key_groups:
            - age:
                - age18nfkzf6c32fnysaeuh64ryqj5dhm8j5f84rl50dc6yuevl87v9esn7nzqu
        - path_regex: secrets/anorLondo/.*\.yaml$
          key_groups:
            - age:
                - age18nfkzf6c32fnysaeuh64ryqj5dhm8j5f84rl50dc6yuevl87v9esn7nzqu
        - path_regex: secrets/(firelink|server)/.*\.yaml$
          key_groups:
            - age:
                - age18nfkzf6c32fnysaeuh64ryqj5dhm8j5f84rl50dc6yuevl87v9esn7nzqu
    '';

    home.activation.setupSopsAge = config.lib.dag.entryAfter ["writeBoundary"] ''
      if [ -f ${config.home.homeDirectory}/.ssh/id_ed25519 ]; then
        $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ${config.home.homeDirectory}/.config/sops/age
        $DRY_RUN_CMD ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i ${config.home.homeDirectory}/.ssh/id_ed25519 > ${config.home.homeDirectory}/.config/sops/age/keys.txt
        $DRY_RUN_CMD chmod $VERBOSE_ARG 600 ${config.home.homeDirectory}/.config/sops/age/keys.txt
      fi
    '';

    sops = {
      age.sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
      defaultSopsFormat = "yaml";
    };
  };

  flake.nixosModules.sops = {config, ...}: {
    imports = [inputs.sops-nix.nixosModules.sops];

    home-manager.sharedModules = [self.homeModules.sops];
  };
}
