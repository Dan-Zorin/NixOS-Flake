{ config, pkgs, lib, ... }:

{
  options.winapps.enable = lib.mkEnableOption "Windows App virtualization";

  config = lib.mkIf config.winapps.enable {
    # Make sure libvirt and QEMU are running
    services.libvirtd.enable = true;

    # Auto-start SPICE agent for clipboard, etc.
    services.spice-vdagentd.enable = true;

    environment.systemPackages = with pkgs; [
      spice
      spice-gtk
      spice-vdagent
      virt-manager
      winapps
    ];

    # Optional: firewall tweaks for local SPICE
    networking.firewall.allowedTCPPorts = [ 5900 5901 5902 ];
    networking.firewall.allowedUDPPorts = [ 5900 5901 5902 ];

    # Declare VM storage and GPU options
    virtualisation.libvirtd.qemu.verbatimConfig = ''
      nvram = [
        "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"
      ]
    '';

    virtualisation.libvirtd.qemu.extraConfig = ''
      # Enable virglrenderer for 3D acceleration
      display = "spice,gl=on"
      video = "virtio"
    '';
  };
}
