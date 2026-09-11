# Declarative disk layout for xenhost, used by nixos-anywhere to partition
# and format during install. Confirmed via SSH into the booted installer:
#   - /dev/sda: Lexar SSD NS100 256GB (SATA), the only real disk --
#     /dev/sdb is the Ventoy installer USB stick, not a target.
#   - UEFI boot confirmed (/sys/firmware/efi present).
#   - Unencrypted, per explicit choice (dedicated research box).
# Addressed by /dev/disk/by-id rather than /dev/sda so this doesn't shift
# if another disk is ever added.
{
  disko.devices = {
    disk.main = {
      device = "/dev/disk/by-id/ata-Lexar_SSD_NS100_256GB_PFR706W1027800S33N";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
