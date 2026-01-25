{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      roboto
      work-sans
      comic-neue
      source-sans
      comfortaa
      inter
      lato
      lexend
      jost
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.lilex
      nerd-fonts.blex-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.caskaydia-cove
      nerd-fonts.meslo-lg
      nerd-fonts.symbols-only
      openmoji-color
      twemoji-color-font
    ];

    enableDefaultPackages = false;
  };
}
