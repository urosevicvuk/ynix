# Noctalia Shell - Wayland desktop shell built with QuickShell
{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [inputs.noctalia.homeModules.default];

  home.packages = with pkgs; [
    # Required dependencies (from docs.noctalia.dev)
    inputs.quickshell.packages.${pkgs.system}.default  # Core framework
    brightnessctl  # Brightness control
    git  # Plugin system and updates
  ];

  programs.noctalia-shell = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.system}.default;

    # Integrate with stylix colors
    #colors = let
    #  colors = config.lib.stylix.colors;
    #in {
    #  mPrimary = "#${colors.base0D}";
    #  mOnPrimary = "#${colors.base00}";
    #  mPrimaryContainer = "#${colors.base01}";
    #  mOnPrimaryContainer = "#${colors.base0D}";

    #  mSecondary = "#${colors.base0D}";
    #  mOnSecondary = "#${colors.base00}";
    #  mSecondaryContainer = "#${colors.base01}";
    #  mOnSecondaryContainer = "#${colors.base0D}";

    #  mTertiary = "#${colors.base0D}";
    #  mOnTertiary = "#${colors.base00}";
    #  mTertiaryContainer = "#${colors.base01}";
    #  mOnTertiaryContainer = "#${colors.base0D}";

    #  mError = "#${colors.base08}";
    #  mOnError = "#${colors.base00}";
    #  mErrorContainer = "#${colors.base01}";
    #  mOnErrorContainer = "#${colors.base08}";

    #  mBackground = "#${colors.base00}";
    #  mOnBackground = "#${colors.base05}";
    #  mSurface = "#${colors.base01}";
    #  mOnSurface = "#${colors.base05}";
    #  mSurfaceVariant = "#${colors.base02}";
    #  mOnSurfaceVariant = "#${colors.base04}";

    #  mOutline = "#${colors.base03}";
    #  mOutlineVariant = "#${colors.base02}";
    #  mShadow = "#${colors.base00}";
    #  mScrim = "#${colors.base00}";
    #  mInverseSurface = "#${colors.base06}";
    #  mInverseOnSurface = "#${colors.base00}";
    #  mInversePrimary = "#${colors.base0D}";
    #};
  };
}
