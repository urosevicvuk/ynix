{...}: {
  flake.homeModules.davinciResolve = {pkgs, ...}: {
    home.packages = with pkgs; [
      davinci-resolve
    ];
  };
}
