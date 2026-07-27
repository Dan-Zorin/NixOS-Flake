{ lib, vars, ... }:

{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = vars.disk;

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

          swap = {
            size = "10G";

            content = {
              type = "swap";
              randomEncryption = false;
            };
          };

          root = {
            size = "100%";

            content = {
              type = "btrfs";

              extraArgs = [ "-f" ];

              subvolumes = {
                "@" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd:3"
                    "noatime"
                    "discard=async"
                  ];
                };

                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "compress=zstd:3"
                    "noatime"
                    "discard=async"
                  ];
                };

                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd:3"
                    "noatime"
                    "discard=async"
                  ];
                };

                "@var" = {
                  mountpoint = "/var";
                  mountOptions = [
                    "compress=zstd:3"
                    "noatime"
                    "discard=async"
                  ];
                };

                "@snapshots" = {
                  mountpoint = "/.snapshots";
                  mountOptions = [
                    "compress=zstd:3"
                    "noatime"
                    "discard=async"
                  ];
                };

                "@persist" = {
                  mountpoint = "/persist";
                  mountOptions = [
                    "compress=zstd:3"
                    "noatime"
                    "discard=async"
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