{ config, pkgs, ... }:

{
  # Override HDMI EDID with extracted version
  boot.kernelParams = [
    "drm.edid_firmware=HDMI-A-1:edid/tv-edid.bin"
  ];

  # Install uncompressed EDID firmware
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [
    (pkgs.runCommand "tv-edid-firmware" {} ''
      mkdir -p $out/lib/firmware/edid
      install -m 644 ${../edid/tv-edid.bin} $out/lib/firmware/edid/tv-edid.bin
    '')
  ];
}