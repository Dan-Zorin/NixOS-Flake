{ lib, ... }:

{
  disko.devices = {
    disk.main = {
      type = "disk";
      # Change this to your SSD
      device = "/dev/disk/by-id/YOUR_DISK_ID";

      content = {
        type = "gpt";

        partitions = {
          ESP = {
            label = "EFI";
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
              type = "btrfs";

              extraArgs = [ "-f" ];

              subvolumes = {
                "@root" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd:3"
                    "noatime"
                  ];
                };

                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "compress=zstd:3"
                    "noatime"
                  ];
                };

                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd:3"
                    "noatime"
                  ];
                };

                "@persist" = {
                  mountpoint = "/persist";
                  mountOptions = [
                    "compress=zstd:3"
                    "noatime"
                  ];
                };

                "@snapshots" = {
                  mountpoint = "/.snapshots";
                  mountOptions = [
                    "compress=zstd:3"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}