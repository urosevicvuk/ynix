{
  # ═══════════════════════════════════════════════════════════════════════════
  # DISKO CONFIGURATION - ariandel (Framework AMD Laptop)
  # ═══════════════════════════════════════════════════════════════════════════
  #
  # Storage Stack: LUKS → LVM → BTRFS
  # Layout: EFI (1GB) + LUKS (encrypted) → [Swap 32GB + BTRFS root]
  # Features: Full disk encryption, hibernate support, TPM2 auto-unlock
  #
  # ═══════════════════════════════════════════════════════════════════════════
  # INSTALLATION INSTRUCTIONS
  # ═══════════════════════════════════════════════════════════════════════════
  #
  # 1. BOOT FROM NIXOS INSTALLER (make sure you have internet)
  #
  # 2. PREPARE ENCRYPTION PASSWORD:
  #    echo "your-strong-password" > /tmp/disk-password.txt
  #
  # 3. VERIFY DISK PATH (adjust device path below if needed):
  #    lsblk
  #
  # 4. RUN DISKO (this will DESTROY all data on /dev/nvme0n1):
  #    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko \
  #      -- --mode disko /home/vyke/code/ynix/hosts/ariandel/disko.nix
  #
  # 5. INSTALL NIXOS:
  #    sudo nixos-install --flake /home/vyke/code/ynix#ariandel
  #
  # 6. REBOOT:
  #    reboot
  #    (You'll need to enter the LUKS password manually on first boot)
  #
  # 7. AFTER FIRST BOOT - ENROLL TPM2 FOR AUTO-UNLOCK (optional but recommended):
  #    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/nvme0n1p2
  #    (This enables auto-unlock on normal boots while keeping password fallback)
  #
  # ═══════════════════════════════════════════════════════════════════════════

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            # ─────────────────────────────────────────────────────────────────
            # EFI System Partition (unencrypted, required for boot)
            # ─────────────────────────────────────────────────────────────────
            ESP = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "fmask=0077"
                  "dmask=0077"
                ];
              };
            };

            # ─────────────────────────────────────────────────────────────────
            # LUKS Encrypted Partition (contains everything else)
            # ─────────────────────────────────────────────────────────────────
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";

                # Password file for initial installation
                # After install, enroll TPM2 for auto-unlock
                passwordFile = "/tmp/disk-password.txt";

                settings = {
                  allowDiscards = true; # Critical for SSD performance/longevity
                };

                # LVM inside LUKS
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
      };
    };

    # ═══════════════════════════════════════════════════════════════════════
    # LVM Volume Group (inside LUKS encryption)
    # ═══════════════════════════════════════════════════════════════════════
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          # ───────────────────────────────────────────────────────────────────
          # Encrypted Swap (for hibernate support)
          # 32GB = 24GB RAM + 8GB buffer for safety
          # ───────────────────────────────────────────────────────────────────
          swap = {
            size = "32G";
            content = {
              type = "swap";
              randomEncryption = false; # Don't random encrypt (needed for hibernate)
              resumeDevice = true; # Enable hibernation
            };
          };

          # ───────────────────────────────────────────────────────────────────
          # Root Filesystem (BTRFS with subvolumes)
          # Uses all remaining space (~1.77TB)
          # ───────────────────────────────────────────────────────────────────
          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = ["-f"]; # Force format

              # BTRFS subvolumes for organization and independent snapshots
              subvolumes = {
                # ─────────────────────────────────────────────────────────────
                # Root subvolume (/)
                # ─────────────────────────────────────────────────────────────
                "@" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd" # Transparent compression
                    "noatime" # Don't update access times (better perf)
                    "commit=120" # Reduce commit frequency for SSD
                  ];
                };

                # ─────────────────────────────────────────────────────────────
                # Nix store (/nix)
                # Separated so it can have different mount options
                # ─────────────────────────────────────────────────────────────
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "commit=120"
                  ];
                };

                # ─────────────────────────────────────────────────────────────
                # Home directories (/home)
                # Separated so root can be snapshotted without including home
                # ─────────────────────────────────────────────────────────────
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "commit=120"
                  ];
                };

                # ─────────────────────────────────────────────────────────────
                # System logs (/var/log)
                # Separated to prevent logs from filling root
                # ─────────────────────────────────────────────────────────────
                "@var_log" = {
                  mountpoint = "/var/log";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "commit=120"
                  ];
                };

                # ─────────────────────────────────────────────────────────────
                # Snapshots directory (/.snapshots)
                # For timeshift/snapper or manual snapshots
                # ─────────────────────────────────────────────────────────────
                "@snapshots" = {
                  mountpoint = "/.snapshots";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "commit=120"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # RESULTING DISK LAYOUT
  # ═══════════════════════════════════════════════════════════════════════════
  #
  # /dev/nvme0n1 (1.8TB SSD)
  # ├─ nvme0n1p1: EFI System Partition (1GB, FAT32, unencrypted)
  # │              → /boot
  # │
  # └─ nvme0n1p2: LUKS Container (~1.8TB, encrypted)
  #    └─ /dev/mapper/crypted (LVM Physical Volume)
  #       └─ pool (Volume Group)
  #          ├─ swap (32GB) → encrypted swap for hibernate
  #          │
  #          └─ root (~1.77TB) → BTRFS
  #             ├─ @          → /           (root filesystem)
  #             ├─ @nix       → /nix        (Nix store)
  #             ├─ @home      → /home       (user data)
  #             ├─ @var_log   → /var/log    (system logs)
  #             └─ @snapshots → /.snapshots (backups)
  #
  # ═══════════════════════════════════════════════════════════════════════════
  # FEATURES
  # ═══════════════════════════════════════════════════════════════════════════
  #
  # ✓ Full disk encryption (except /boot EFI partition)
  # ✓ Encrypted swap for safe hibernation
  # ✓ TPM2 auto-unlock (enroll after first boot)
  # ✓ Password fallback (if TPM fails or Secure Boot disabled)
  # ✓ BTRFS compression (transparent, saves ~30-40% space)
  # ✓ Subvolume isolation (snapshot root without snapshotting home/nix)
  # ✓ SSD-optimized (noatime, commit=120, allowDiscards)
  # ✓ Framework AMD laptop optimizations
  #
  # ═══════════════════════════════════════════════════════════════════════════
}
