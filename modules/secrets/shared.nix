{inputs, ...}: {
  flake.homeModules.base = {
    config,
    pkgs,
    ...
  }: {
    imports = [inputs.sops-nix.homeManagerModules.sops];

    # Declaratively manage .sops.yaml
    home.file."/home/vyke/code/ynix/.sops.yaml".text = ''
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

    home.packages = with pkgs; [
      sops
      age
      ssh-to-age
    ];

    home.activation.setupSopsAge = config.lib.dag.entryAfter ["writeBoundary"] ''
      if [ -f /home/vyke/.ssh/id_ed25519 ]; then
        $DRY_RUN_CMD mkdir -p $VERBOSE_ARG /home/vyke/.config/sops/age
        $DRY_RUN_CMD ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i /home/vyke/.ssh/id_ed25519 > /home/vyke/.config/sops/age/keys.txt
        $DRY_RUN_CMD chmod $VERBOSE_ARG 600 /home/vyke/.config/sops/age/keys.txt
      fi
    '';

    sops = {
      age.sshKeyPaths = ["/home/vyke/.ssh/id_ed25519"];
      defaultSopsFormat = "yaml";

      #secrets = {
      #    "anthropic-api-key" = {
      #      sopsFile = ../../secrets/shared/anthropic.yaml;
      #      key = "api_key";
      #      mode = "0400";
      #    };
      #  };
    };
  };
}
