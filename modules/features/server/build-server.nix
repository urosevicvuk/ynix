# Build server — firelink accepts remote builds from the workstations. Trusting
# the user lets its nix daemon run our builds. The client half is
# system/core/builds.nix; since firelink imports the base group it also picks up
# that client config, so here it opts back OUT — it must never ssh to itself to
# build.
{...}: {
  flake.nixosModules.buildServer = {
    config,
    lib,
    ...
  }: {
    nix.settings.trusted-users = [config.preferences.username];

    # Undo the base client role on this host.
    nix.distributedBuilds = lib.mkForce false;
    nix.buildMachines = lib.mkForce [];
  };
}
