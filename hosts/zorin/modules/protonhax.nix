{ config, pkgs, lib, ... }:

let
  protonhaxPkg = pkgs.stdenv.mkDerivation {
    pname = "protonhax";
    version = "2024-01-01";

    src = pkgs.fetchgit {
      url = "https://github.com/jcnils/protonhax";
      rev = "922a7bbade5a93232b3152cc20a7d8422db09c31";
      sha256 = "sha256-P6DVRz8YUF4JY2tiEVZx16FtK4i/rirRdKKZBslbJxU=";
    };

    installPhase = ''
      mkdir -p $out/bin
      cp $src/protonhax $out/bin/protonhax

      sed -i "s|#!/bin/bash|#!${pkgs.bash}/bin/bash|" $out/bin/protonhax
      chmod +x $out/bin/protonhax

      # helper wrapper
      cat <<EOF > $out/bin/protonhax-run
#!${pkgs.bash}/bin/bash
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: protonhax-run <STEAM_APPID> <command...>"
  exit 1
fi
appid="$1"
shift
protonhax exec "$appid" "$@"
EOF

      chmod +x $out/bin/protonhax-run
    '';
  };
in {
  options.services.protonhax.enable = lib.mkEnableOption "Enable Protonhax system integration";

  config = lib.mkIf config.services.protonhax.enable {

    environment.systemPackages = [ protonhaxPkg ];

    # Steam integration
    environment.variables.STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      lib.mkBefore "${protonhaxPkg}/share/steam/compatibilitytools.d";

    # Best compatibility for protonhax scripts (fixes sandboxing issues)
    security.wrappers.protonhax = {
      source = "${protonhaxPkg}/bin/protonhax";
      owner = "root";
      group = "root";
      permissions = "a+rx";
    };
  };
}