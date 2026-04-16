# btop system monitor
{ ... }: {
  flake.homeModules.base = { pkgs, lib, ... }: {
    programs.btop = {
      enable = true;
      package = pkgs.btop-rocm;
      settings = {
        vim_keys = true;
        color_theme = lib.mkForce "gruvbox_dark_v2";
      };
    };
  };
}
