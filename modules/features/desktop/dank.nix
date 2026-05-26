{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.dank = {...}: {
    home-manager.sharedModules = [self.homeModules.dank];
  };

  flake.homeModules.dank = {
    pkgs,
    ...
  }: {
    imports = [inputs.dms.homeModules.dank-material-shell];

    home.packages = with pkgs; [
      material-symbols
      inter
      cliphist
      ddcutil
      brightnessctl
      playerctl
      cava
      grim
      slurp
      wl-clipboard
    ];

    programs.dank-material-shell = {
      enable = true;
    };
  };
}
