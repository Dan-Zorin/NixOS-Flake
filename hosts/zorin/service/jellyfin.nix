{ config, pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
    openFirewall = true;  # opens 8096 (http) and related ports
    user = "jellyfin";
    group = "jellyfin";
  };

  # NVIDIA hardware transcoding needs the jellyfin user in the right groups
  # and the NVIDIA driver's video/compute libs available
  users.users.jellyfin.extraGroups = [ "video" "render" ];

  # Make sure nvidia-vaapi/nvenc userspace libs are visible to jellyfin's ffmpeg
  hardware.graphics.enable = true; # (was hardware.opengl on older releases)
}