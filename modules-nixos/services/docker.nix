{
  config,
  pkgs,
  ...
}: let
  inherit (config.var) username;
in {
  virtualisation.docker = {
    enable = true;

    #  daemon.settings = {
    #    log-driver = "json-file";
    #    log-opts = {
    #      max-size = "10m";
    #      max-file = "5";
    #    };
    #    dns = [
    #      "172.17.0.1"
    #      "8.8.8.8"
    #      "1.1.1.1"
    #    ];
    #    bip = "172.17.0.1/16";
    #  };

    #  autoPrune = {
    #    enable = true;
    #    dates = "weekly";
    #  };
  };

  #services.resolved = {
  #  enable = true;
  #  extraConfig = ''
  #    DNSStubListenerExtra=172.17.0.1
  #  '';
  #};

  #systemd.services.docker = {
  #  serviceConfig = {
  #    DefaultDependencies = false;
  #  };
  #};

  users.users.${username}.extraGroups = ["docker"];

  environment.systemPackages = with pkgs; [
    lazydocker
    docker-compose
  ];
}
