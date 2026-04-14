{
  config,
  inputs,
  ...
}:
let
  hm = config.flake.modules.homeManager;
  username = "vyke";
in
{
  flake.modules.nixos = {
    core = [
      (
        { ... }:
        {
          imports = [ inputs.home-manager.nixosModules.home-manager ];
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-backup";
            extraSpecialArgs = { inherit inputs; };
            users.${username} = {
              imports = hm.core;
              home = {
                inherit username;
                homeDirectory = "/home/${username}";
              };
              programs.home-manager.enable = true;
            };
          };
        }
      )
    ];
    desktop = [
      (
        { ... }:
        {
          home-manager.users.${username}.imports = hm.desktop;
        }
      )
    ];
    programs = [
      (
        { ... }:
        {
          home-manager.users.${username}.imports = hm.programs ++ hm.nvim ++ hm.scripts;
        }
      )
    ];
  };
}
