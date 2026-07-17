# Colmena — deploy the whole fleet with one command instead of ssh-ing into each
# box to run nixos-rebuild.
#
#   colmena apply                 # build + push + activate every host, in parallel
#   colmena apply --on @desktop   # only the tagged desktops
#   colmena apply --on firelink   # a single host
#   colmena build                 # just build everything (dry, no push)
#
# Each node just imports the host module we already assembled; the `deployment`
# block is colmena's own (targeting over the tailnet as user vyke). CLI is in the
# repo devShell (`nix develop`, or direnv).
#
# meta.nixpkgs is the Nixpkgs *lambda* (unapplied import), so each node's own
# nixpkgs.config — allowUnfree, permittedInsecurePackages from nix.nix — resolves
# normally rather than being overridden by a pre-imported pkgs set.
{
  self,
  inputs,
  ...
}: {
  flake.colmenaHive = inputs.colmena.lib.makeHive {
    meta = {
      nixpkgs = import inputs.nixpkgs {system = "x86_64-linux";};
      nodeNixpkgs = {}; # per-node overrides, none needed (all x86_64-linux)
      specialArgs = {inherit self inputs;};
    };

    defaults = {
      deployment = {
        targetUser = "vyke"; # root login is disabled; vyke escalates via sudo
        buildOnTarget = false; # build on the deployer (offloads to firelink anyway)
      };
    };

    anorLondo = {
      deployment = {
        targetHost = "anorlondo";
        tags = ["desktop"];
      };
      imports = [self.nixosModules.anorLondo];
    };

    ariandel = {
      deployment = {
        targetHost = "ariandel";
        tags = ["desktop" "laptop"];
      };
      imports = [self.nixosModules.ariandel];
    };

    firelink = {
      deployment = {
        targetHost = "firelink";
        tags = ["server"];
        # It's the beefy always-on box — build the server closure on it directly
        # rather than shipping it across the tailnet.
        buildOnTarget = true;
      };
      imports = [self.nixosModules.firelink];
    };
  };
}
