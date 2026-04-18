{
  flake.homeModules.base = {pkgs, ...}: {
    # TODO: set up basic config after some use, this is just a starting point
    # also learn to use this, looks really fucking nice
    home.packages = with pkgs; [
      jujutsu
      jjui
    ];
  };
}
