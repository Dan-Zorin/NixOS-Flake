{ config, pkgs, lib, ... }:
{
  # ← was systemd.extraConfig
  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "15s";
    DefaultTimeoutAbortSec = "15s";
  };

  systemd.user.extraConfig = ''
    DefaultTimeoutStopSec=15s
  '';
}