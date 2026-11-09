# ms02: UEFI, one NVMe SSD, GPT, encrypted ephemeral swap, ext4 root.
# Running Disko formatting/reinstallation erases data; normal rebuilds do not.
{ ... }:
{
  disko.devices.disk.main = {
    type = "disk";
    # Stable identity for the 1 TB WD NVMe SSD.
    device = "/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b444a498b8aa9";

    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };

        swap = {
          priority = 2;
          size = "8G";
          content = {
            type = "swap";
            randomEncryption = true;
          };
        };

        root = {
          priority = 3;
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
}
