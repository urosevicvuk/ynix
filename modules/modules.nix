# Central composition file.
# One place to see every bundle's contents and how homeModules wire into nixosModules.
{
  self,
  inputs,
  lib,
  ...
}: let
  # Auto-wire every homeModule into a matching nixosModule.
  # homeModules.zen → nixosModules.zen, homeModules.discord → nixosModules.discord, etc.
  # This lets bundles compose atomics uniformly as a flat list of nixosModules,
  # with no manual wiring per-module and no home/system distinction at the call site.
  # "base" is the only exclusion — it needs a custom nixosModules definition below.
  wired =
    lib.mapAttrs
    (_: home: {config, ...}: {
      home-manager.users.${config.preferences.username}.imports = [home];
    })
    (lib.filterAttrs (name: _: name != "base") self.homeModules);

  # Compose a bundle nixosModule from a flat list of nixosModules.
  # System-level atomics (docker, steam…) and auto-wired home atomics are all nixosModules,
  # so they can be mixed freely in one list.
  group = modules: _: {imports = modules;};
in {
  flake.nixosModules =
    wired
    // {
      # Foundation — every host.
      # Sets up home-manager and wires homeModules.base + homeModules.sops into the user.
      base = {config, ...}: {
        imports = [inputs.home-manager.nixosModules.default];

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "hm-backup";
          extraSpecialArgs = {themeData = config.theme;};
          users.${config.preferences.username} = {
            imports = [
              self.homeModules.base
              self.homeModules.sops
            ];
            home.stateVersion = "24.05";
            home.username = config.preferences.username;
            home.homeDirectory = "/home/${config.preferences.username}";
            programs.home-manager.enable = true;
          };
        };
      };

      # Groups — compose auto-wired atomics into logical groups.

      core = group [
        self.nixosModules.zen
        self.nixosModules.helium
        self.nixosModules.discord
        self.nixosModules.spicetify
      ];

      dev = group [
        self.nixosModules.dev-utils
        self.nixosModules.ai
        self.nixosModules.jetbrains
        self.nixosModules.docker
      ];

      gaming = group [
        self.nixosModules.steam
        self.nixosModules.gamemode
      ];

      creative = group [
        self.nixosModules.affinity
        self.nixosModules.davinciResolve
        self.nixosModules.figma
        self.nixosModules.obsStudio
      ];

      work = group [
        self.nixosModules.office
      ];
    };
}
