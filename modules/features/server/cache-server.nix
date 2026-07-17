# Binary cache server — harmonia serves firelink's /nix/store, signed with a
# sops-encrypted key, over http on :5000. Reachable via the trusted tailscale0
# interface, so no port is opened. The client half is system/core/binary-cache.nix.
#
# systemd LoadCredential reads the signing key as root at start, so a 0400
# root-owned secret works despite harmonia running as a DynamicUser.
{...}: {
  flake.nixosModules.cacheServer = {config, ...}: {
    services.harmonia = {
      enable = true;
      cache.signKeyPaths = [config.sops.secrets."harmonia-signing-key".path];
      settings.bind = "[::]:5000";
    };

    sops.secrets."harmonia-signing-key" = {
      sopsFile = ../../secrets/firelink/harmonia.yaml;
      key = "signing_key";
      mode = "0400";
    };
  };
}
