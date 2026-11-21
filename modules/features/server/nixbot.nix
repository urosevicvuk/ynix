{inputs, ...}: {
  flake.nixosModules.nixbot = {config, ...}: let
    domain = "nixbot.urosevicvuk.dev";

    tunnelId = "00000000-0000-0000-0000-000000000000";
    githubAppId = 0;
    githubOauthClientId = "Iv23li0000000000000";

    secret = key: {
      sopsFile = ../../../secrets/firelink/nixbot.yaml;
      inherit key;
      mode = "0400";
    };
  in {
    imports = [inputs.nixbot.nixosModules.nixbot];

    services.nixbot = {
      enable = true;
      inherit domain;

      nginx.enable = false;
      useHTTPS = true;

      admins = ["github:urosevicvuk"];

      github = {
        enable = true;
        appId = githubAppId;
        appSecretKeyFile = config.sops.secrets."nixbot/github-app-key".path;
        webhookSecretFile = config.sops.secrets."nixbot/github-webhook-secret".path;
        oauthId = githubOauthClientId;
        oauthSecretFile = config.sops.secrets."nixbot/github-oauth-secret".path;

        userAllowlist = ["urosevicvuk"];
        topic = null;
      };

      prApproval = {
        enable = true;
        trustedAssociations = ["OWNER"];
      };

      buildSystems = ["x86_64-linux"];
      evalSystems = ["x86_64-linux"];

      evalWorkerCount = 8;
      evalMaxMemorySize = 4096;
    };

    nix.daemonCPUSchedPolicy = "batch";
    nix.daemonIOSchedClass = "idle";

    services.cloudflared = {
      enable = true;
      tunnels.${tunnelId} = {
        credentialsFile = config.sops.secrets."nixbot/tunnel-credentials".path;
        ingress.${domain} = "http://localhost:${toString config.services.nixbot.port}";
        default = "http_status:404";
      };
    };

    sops.secrets = {
      "nixbot/github-app-key" = secret "github_app_private_key";
      "nixbot/github-webhook-secret" = secret "github_webhook_secret";
      "nixbot/github-oauth-secret" = secret "github_oauth_client_secret";
      "nixbot/tunnel-credentials" = secret "tunnel_credentials";
    };
  };
}
