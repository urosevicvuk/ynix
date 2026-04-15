{
  config,
  inputs,
  ...
}:
let
  hm = config.flake.homeModules;
in
{
  flake.nixosModules = {
    base = { config, ... }: {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";
        users.${config.preferences.username} = {
          imports = [ hm.base ];
          home = {
            username = config.preferences.username;
            homeDirectory = "/home/${config.preferences.username}";
          };
          programs.home-manager.enable = true;
        };
      };
    };
    desktop = { config, ... }: {
      home-manager.users.${config.preferences.username}.imports = [ hm.desktop ];
    };
    dev = { config, ... }: {
      home-manager.users.${config.preferences.username}.imports = [ hm.dev ];
    };
  };
}
