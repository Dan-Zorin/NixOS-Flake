{ config, pkgs, lib, ... }:

{
  options.winapp.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Windows VM for Winapps (e.g. Dragon City, Office, etc)";
  };

  config = lib.mkIf config.winapp.enable {

    # --- Virtualization Base ---
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = lib.mkDefault pkgs.qemu_kvm; # no conflicts
          swtpm.enable = true;
        };
      };

      spiceUSBRedirection.enable = true;
    };

    # --- Packages for Virtualization + Winapps ---
    environment.systemPackages = with pkgs; [
      virt-manager
      spice
      spice-gtk
      spice-vdagent
      virtio-win
      virglrenderer
      winetricks
      wineWowPackages.stableFull
      qemu
    ];

    # --- User Permissions ---
    users.users.zorin.extraGroups = [ "libvirtd" "kvm" "qemu-libvirtd" ];

    # --- Optional networking setup for VMs ---
    networking.firewall.allowedTCPPorts = [ 5900 5901 3389 ];
    networking.firewall.allowedUDPPorts = [ 5900 5901 ];

    # --- Optional Winapp setup path (for future automation) ---
    environment.etc."winapp/config".text = ''
      [vm]
      name = "Winapp"
      image = "/var/lib/libvirt/images/winapp.qcow2"
      ram = 8192
      cores = 6
    '';
  };
}

