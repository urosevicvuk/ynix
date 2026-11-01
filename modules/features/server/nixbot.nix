# nixbot — Nix-native CI. Builds every enabled repo's `.#checks` on GitHub
# pushes and pull requests, and reports them back as check runs. Setup steps
# (tunnel, GitHub App, secrets): docs/nixbot.md.
#
# Reached from the internet only through its own Cloudflare tunnel, which runs
# here on the host rather than in k3s, so CI keeps working while the cluster is
# down or being rebuilt. The tunnel exposes the whole UI: GitHub's OAuth
# callback has to reach it, anonymous visitors only see public repos, and
# anything that changes state needs a GitHub login.
#
# Pull requests from anyone but the repo owner are held until approved (the
# "Approve CI" button on the PR); the templates' GitHub Actions workflow checks
# those instead.
{inputs, ...}: {
  flake.nixosModules.nixbot = {config, ...}: let
    domain = "nixbot.urosevicvuk.dev";

    # Not secret, but only known once created — docs/nixbot.md, steps 1 and 2.
    tunnelId = "00000000-0000-0000-0000-000000000000";
    githubAppId = 0;
    githubOauthClientId = "Iv23li0000000000000";

    secret = key: {
      sopsFile = ../../../secrets/firelink/nixbot.yaml;
      inherit key;
      mode = "0400"; # both services read these through systemd LoadCredential, as root
    };
  in {
    imports = [inputs.nixbot.nixosModules.nixbot];

    services.nixbot = {
      enable = true;
      inherit domain;

      # cloudflared terminates TLS and forwards plain http to the port, so no
      # nginx; useHTTPS still makes every link nixbot generates https.
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

        # Never build repos the App gets installed on outside this account.
        userAllowlist = ["urosevicvuk"];
        # Projects are switched on in the web UI instead.
        topic = null;
      };

      prApproval = {
        enable = true;
        trustedAssociations = ["OWNER"];
      };

      # Only x86_64 builders exist; the templates also expose aarch64-linux
      # outputs, which would otherwise queue up with nowhere to build.
      buildSystems = ["x86_64-linux"];
      evalSystems = ["x86_64-linux"];

      # The default is one 2 GiB worker per core (40 here). NixOS
      # configurations need more memory each, and fewer workers are plenty.
      evalWorkerCount = 8;
      evalMaxMemorySize = 4096;
    };

    # CI shares the box with k3s: builds get the CPU and disk whenever the
    # cluster isn't using them, and yield when it is.
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
