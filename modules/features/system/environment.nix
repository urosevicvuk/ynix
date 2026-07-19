{
  self,
  inputs,
  ...
}: {
  # Self-registers into the `system` group (merged with the other system modules).
  flake.nixosModules.system.imports = [self.nixosModules.environment];

  flake.nixosModules.environment = {
    pkgs,
    config,
    lib,
    ...
  }: {
    environment = {
      variables = {
        XDG_DATA_HOME = "$HOME/.local/share";
        NH_FLAKE = config.preferences.configDirectory;
        PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
        EDITOR = "nvim";
        TERMINAL = config.preferences.terminal;
        BROWSER = lib.getExe inputs.zen-browser.packages.${pkgs.system}.default;
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
