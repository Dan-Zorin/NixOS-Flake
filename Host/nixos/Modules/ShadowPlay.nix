{ config, pkgs, lib, ... }:

{
  options.my.gpuScreenRecorder.enable = lib.mkEnableOption "Enable GPU Screen Recorder (Flatpak)";

  config = lib.mkIf config.my.gpuScreenRecorder.enable {
    services.flatpak.enable = true;

    home.activation.gpuScreenRecorderInstall = lib.hm.dag.entryAfter ["writeBoundary"] ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      flatpak install -y flathub com.dec05eba.gpu_screen_recorder
    '';
  };
}
