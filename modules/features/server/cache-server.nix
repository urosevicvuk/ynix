{self, ...}: {
  flake.nixosModules.server.imports = [self.nixosModules.cacheServer];

  flake.nixosModules.cacheServer = {config, ...}: {
    services.harmonia.cache = {
      enable = true;
      signKeyPaths = [config.sops.secrets."harmonia-signing-key".path];
      settings.bind = "[::]:5000";
    };

    sops.secrets."harmonia-signing-key" = {
      sopsFile = ../../../secrets/firelink/harmonia.yaml;
      key = "signing_key";
      mode = "0400";
    };
  };
}
