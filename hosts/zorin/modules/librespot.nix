{ config, pkgs, ... }:

{
  # Librespot - Spotify Connect daemon for Strawberry
  systemd.services.librespot = {
    wantedBy = [ "multi-user.target" ];
    description = "Spotify Connect daemon";
    serviceConfig = {
      ExecStart = "${pkgs.librespot}/bin/librespot \
        --name 'Strawberry Connect' \
        --backend alsa \
        --device default \
        --bitrate 320 \
        --enable-volume-normalisation true";
      Restart = "always";
      User = "zorin";
    };
  };
}