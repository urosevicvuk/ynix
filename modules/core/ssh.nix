{
  flake.modules.nixos.core = [
    (
      { ... }:
      {
        services.openssh = {
          enable = true;
          ports = [ 22 ];
          openFirewall = true;
          settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = false;
            AllowUsers = [ "vyke" ];
          };
        };
        users.users.vyke.openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQpgKiftVTzqkfu6zbRpvZFtWZH/HBQSj6DhuVvVRul vuk23urosevic@gmail.com"
        ];
      }
    )
  ];
}
