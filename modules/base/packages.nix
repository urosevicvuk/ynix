# Additional base packages shared across all hosts
{
  flake.homeModules.base = { pkgs, ... }: {
    home.packages = with pkgs; [
      nix-init
      ntfs3g
      p7zip
      ffmpeg
      optipng
      zip
      unzip
      moreutils
      wireguard-tools

      # rice
      peaclock
      cbonsai
      pipes
      cmatrix
      neo-cowsay
    ];
  };
}
