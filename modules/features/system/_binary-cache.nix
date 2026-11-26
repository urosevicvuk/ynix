{self, ...}: {
  flake.nixosModules.system.imports = [self.nixosModules.binaryCache];

  flake.nixosModules.binaryCache = {...}: {
    nix.settings = {
      substituters = ["http://firelink:5000?priority=5"];
      trusted-public-keys = ["firelink-1:sE3HudW/ms0O9N2zxus6znHG1xWekq2Me7gT5uWAyQ0="];
    };
  };
}
