# The 25G triangle between firelink1/2/3: both mesh ports of a node go into
# one bridge, mesh0 (10.10.0.0/24), and STP blocks one of the three links so
# the triangle isn't a loop. Pull a cable and STP reroutes through the third
# node.
#
# systemd-networkd owns the mesh; NetworkManager keeps everything else (eno1,
# the BMC's USB NIC) and is told to leave mesh0 and its ports alone.
#
#   ynix.mesh = {
#     address = "10.10.0.1";
#     ports = ["ens4f0np0" "ens4f1np1"];
#     gateway = "10.10.0.2";   # nodes without their own uplink
#   };
{...}: {
  flake.nixosModules.mesh = {
    config,
    lib,
    ...
  }: let
    cfg = config.ynix.mesh;
  in {
    options.ynix.mesh = with lib; {
      address = mkOption {
        type = types.str;
        description = "This node's address on mesh0 (a /24).";
      };
      ports = mkOption {
        type = types.listOf types.str;
        description = "The two 25G interfaces cabled into the triangle.";
      };
      gateway = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Default route over the mesh, for nodes without their own uplink.";
      };
      uplink = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Interface to NAT mesh traffic out of (makes this node the mesh's gateway).";
      };
      dns = mkOption {
        type = types.listOf types.str;
        default = ["1.1.1.1" "9.9.9.9"];
        description = "Nameservers for nodes using `gateway` (no LAN DHCP to hand them out).";
      };
      extraAddresses = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "More CIDR addresses on mesh0 (migrations).";
      };
      stpPriority = mkOption {
        type = types.int;
        default = 32768;
        description = "Lowest becomes the STP root; make it the gateway.";
      };
      mtu = mkOption {
        type = types.int;
        default = 1500;
        description = "Raise to 9000 only after `ping -M do -s 8972` works on every link.";
      };
    };

    config = {
      networking.networkmanager.unmanaged = map (i: "interface-name:${i}") (["mesh0"] ++ cfg.ports);

      # networkd turns systemd-resolved on by default. Keep the resolvconf
      # setup these hosts already have: switching resolvers rewrites
      # tailscaled's unit, and a tailscaled restart in the middle of the
      # network change left it stuck logging in (firelink1, the first try).
      services.resolved.enable = false;

      systemd.network = {
        enable = true;
        # Nothing waits on the mesh at boot.
        wait-online.enable = false;
        # Only touch what networkd configured itself: Tailscale's ip rules and
        # table 52 aren't networkd's to clean up.
        config.networkConfig = {
          ManageForeignRoutingPolicyRules = false;
          ManageForeignRoutes = false;
        };

        netdevs."10-mesh0" = {
          netdevConfig = {
            Kind = "bridge";
            Name = "mesh0";
            MTUBytes = toString cfg.mtu;
          };
          bridgeConfig = {
            STP = true;
            Priority = cfg.stpPriority;
          };
        };

        networks."10-mesh0-ports" = {
          matchConfig.Name = cfg.ports;
          networkConfig.Bridge = "mesh0";
          linkConfig = {
            MTUBytes = toString cfg.mtu;
            RequiredForOnline = "no";
          };
        };

        networks."20-mesh0" = {
          matchConfig.Name = "mesh0";
          address = ["${cfg.address}/24"] ++ cfg.extraAddresses;
          gateway = lib.optional (cfg.gateway != null) cfg.gateway;
          networkConfig = {
            ConfigureWithoutCarrier = true;
            LinkLocalAddressing = "ipv6";
          };
          linkConfig.RequiredForOnline = "no";
        };
      };

      # networkd's DNS= only reaches systemd-resolved (off, above); resolvconf
      # takes these instead.
      networking.nameservers = lib.mkIf (cfg.gateway != null) cfg.dns;

      networking.hosts = {
        "10.10.0.1" = ["firelink1-mesh"];
        "10.10.0.2" = ["firelink2-mesh"];
        "10.10.0.3" = ["firelink3-mesh"];
      };

      networking.firewall.trustedInterfaces = ["mesh0"];

      networking.nat = lib.mkIf (cfg.uplink != null) {
        enable = true;
        internalInterfaces = ["mesh0"];
        externalInterface = cfg.uplink;
      };
    };
  };
}
