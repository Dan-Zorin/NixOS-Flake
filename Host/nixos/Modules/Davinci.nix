{ config, pkgs, ... }:

let
  patchedResolve = pkgs.davinci-resolve-studio.override (old: {
    buildFHSEnv = fhs: let
      davinci = fhs.passthru.davinci.overrideAttrs (oldAttrs: {
        postFixup = ''
          ${oldAttrs.postFixup}
          # Patch activation check (offset for v19.1.4)
          printf '\xEB' | dd of=$out/bin/resolve bs=1 seek=$((0x4B3C)) count=1 conv=notrunc
        '';
      });
    in
    old.buildFHSEnv (fhs // {
      extraBwrapArgs = [
        "--bind ~/.local/share/DaVinciResolve/license /opt/resolve/.license"
        "--bind /run/opengl-driver/etc/OpenCL /etc/OpenCL"
      ];
      runScript = ''
        export QT_XKB_CONFIG_ROOT="${pkgs.xkeyboard_config}/share/X11/xkb"
        unset QT_QPA_PLATFORM
        export __GL_SHADER_DISK_CACHE_PATH="/tmp"
        exec ${davinci}/bin/resolve
      '';
    });
  });
in {
  environment.systemPackages = [ patchedResolve ];

  # Required GPU support
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
  };
}
