{ config, pkgs, ... }:

{
  # Additional drive mounts

  # Media drive (movies, music)
  fileSystems."/media/storage" = {
    device = "/dev/disk/by-uuid/c7f78dc9-fbbe-4a10-a60f-022319a9b245";
    fsType = "btrfs";
    options = [ "defaults" "compress=zstd" "noatime" ];
  };

  # Create mount point and set permissions
  systemd.tmpfiles.rules = [
    "d /media/storage 0755 zorin users -"
  ];
}