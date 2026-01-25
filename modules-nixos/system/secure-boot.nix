{
  pkgs,
  lib,
  ...
}: {
  # Lanzaboote - Secure Boot for NixOS
  # https://github.com/nix-community/lanzaboote
  #
  # NOTE: Lanzaboote wraps systemd-boot with Secure Boot signing.
  # It replaces systemd-boot's bootloader installation, so we must disable systemd-boot here.

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl"; # IMPORTANT: Must match where sbctl stores keys!
  };

  # Disable systemd-boot since lanzaboote handles it
  boot.loader.systemd-boot.enable = lib.mkForce false;

  # Required packages for Secure Boot key management
  environment.systemPackages = [
    pkgs.sbctl # For managing Secure Boot keys
  ];

  # ═══════════════════════════════════════════════════════════════════════
  # SETUP INSTRUCTIONS (from official lanzaboote docs)
  # ═══════════════════════════════════════════════════════════════════════
  #
  # 1. CREATE SECURE BOOT KEYS (before first rebuild):
  #    sudo sbctl create-keys
  #    (Keys will be stored in /var/lib/sbctl with root-only access)
  #
  # 2. REBUILD NIXOS:
  #    sudo nixos-rebuild boot --flake .#hostname
  #    (Lanzaboote will sign all boot files automatically)
  #
  # 3. VERIFY SIGNING:
  #    sudo sbctl verify
  #    (Files ending in "bzImage.efi" should be unsigned, others signed)
  #
  # 4. ENTER BIOS SETUP MODE:
  #    - Reboot into BIOS/UEFI settings
  #    - Navigate to Security → Secure Boot
  #    - Enable Secure Boot
  #    - Select "Reset to Setup Mode" or "Clear Secure Boot Keys"
  #    - Save and exit (DO NOT select "Clear All Secure Boot Keys")
  #
  # 5. ENROLL KEYS:
  #    sudo sbctl enroll-keys --microsoft
  #    (--microsoft flag prevents boot issues from hardware OptionROMs)
  #
  # 6. VERIFY SECURE BOOT:
  #    bootctl status
  #    (Should show "Secure Boot: enabled (user)")
  #
  # TROUBLESHOOTING:
  # - If boot fails: disable Secure Boot in BIOS and check `sudo sbctl verify`
  # - Framework laptops: may need to manually select "Enforce Secure Boot"
  # - ASUS systems: set "OS Type" to "Windows UEFI Mode"
  #
  # NOTE: Windows dual-boot continues to work with --microsoft flag
}
