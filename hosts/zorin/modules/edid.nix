{ config, pkgs, ... }:

{
  # Override HDMI EDID with Windows-extracted version
  boot.kernelParams = [
    "drm.edid_firmware=HDMI-A-1:edid/tv-edid.bin"
  ];

  hardware.firmware = [
    (pkgs.runCommand "tv-edid-firmware" {} ''
      mkdir -p $out/lib/firmware/edid
      cp ${../edid/tv-edid.bin} $out/lib/firmware/edid/tv-edid.bin
    '')
  ];
}