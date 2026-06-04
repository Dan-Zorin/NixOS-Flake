{ config, pkgs, lib, ... }:
{
  powerManagement.enable = true;

  boot.kernelParams = [
    "mem_sleep_default=deep"
    "resume_offset=REPLACE_WITH_OFFSET"
  ];
  boot.resumeDevice = "/dev/disk/by-uuid/REPLACE_WITH_ROOT_UUID";
  security.protectKernelImage = false;

  # ← was systemd.sleep.extraConfig
  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "30min";
    SuspendState = "mem";
  };

  # ← was services.logind.extraConfig
  services.logind.settings.Login = {
    HandlePowerKey = "suspend-then-hibernate";
    HandlePowerKeyLongPress = "poweroff";
  };
}