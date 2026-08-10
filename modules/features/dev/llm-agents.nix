{
  self,
  inputs,
  ...
}: {
  # Self-registers into the `dev` group (merged with the other dev modules).
  flake.nixosModules.dev.imports = [self.nixosModules.llm-agents];

  flake.nixosModules.llm-agents = {pkgs, ...}: {
    environment.systemPackages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      opencode
      opencode2
      claude-code
      claude-desktop
      cursor-agent
      amp
    ];
  };
}
