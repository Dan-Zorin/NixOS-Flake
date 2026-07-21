{ config, pkgs, ... }:

{
  # Podman (Docker alternative)
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;  # Alias docker -> podman
    defaultNetwork.settings.dns_enabled = true;
  };

  # libvirt/QEMU for VMs
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  # Virt-manager GUI
  programs.virt-manager.enable = true;

  # Add user to libvirt group
  users.users.zorin.extraGroups = [ "libvirtd" ];
}