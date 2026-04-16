{...}: {
  flake.homeModules.davinci-resolve = {pkgs, ...}: {
    home.packages = with pkgs; [
      davinci-resolve
    ];
  };
}
