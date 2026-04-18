{
  flake.homeModules.base = {pkgs, ...}: {
    programs.nushell = {
      enable = true;

      settings = {
        edit_mode = "vi";
        cursor_shape = {
          vi_insert = "line";
          vi_normal = "block";
        };
      };
      #extraEnv = ''
      #  PROMPT_INDICATOR_VI_INSERT = " ";
      #  PROMPT_INDICATOR_VI_NORMAL = " ";
      #'';

      plugins = with pkgs.nushellPlugins; [
        polars
        gstat
        query
        formats
        #highlight
        #skim
        #hcl
        #net
        #units
      ];
    };
  };
}
