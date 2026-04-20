{
  flake.nixosModules.environment = {
    pkgs,
    config,
    ...
  }: {
    environment = {
      variables = {
        XDG_DATA_HOME = "$HOME/.local/share";
        NH_FLAKE = config.preferences.configDirectory;
        PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
        EDITOR = "nvim";
        TERMINAL = "kitty";
        BROWSER = "zen";
      };
      systemPackages = with pkgs; [
        fd
        bc
        gcc
        git-ignore
        xdg-utils
        wget
        curl
        vim
        nixfmt
        sops
        age
        nix-init
        ntfs3g
        p7zip
        ffmpeg
        optipng
        zip
        unzip
        moreutils
        wireguard-tools
      ];
      pathsToLink = ["/share/zsh"];
    };
    documentation = {
      enable = true;
      doc.enable = false;
      man.enable = true;
      dev.enable = false;
      info.enable = false;
      nixos.enable = false;
    };
  };
}
