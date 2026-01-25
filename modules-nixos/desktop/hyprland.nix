{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    # Using nixpkgs hyprland for stability
    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = with pkgs; [
    hyprland-qtutils
  ];
}
