{ config, pkgs, ... }:

{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf.enable = true;
      };
    };
  };

  users.users.zorin.extraGroups = [ "libvirtd" "kvm" "qemu-libvirtd" ];

  environment.systemPackages = with pkgs; [
    virt-manager
    spice
    spice-gtk
    spice-vdagent
    virtio-win
    qemu
    virglrenderer
  ];
}

