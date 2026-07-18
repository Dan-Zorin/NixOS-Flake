{ config, pkgs, inputs, ... }:
    {
      programs.uwsm = {
        enable = true;
        waylandCompositors = {
          mango = {
            prettyName = "Mango";
            comment = "Mango compositor managed by UWSM";
            binPath = "${inputs.mangowm.packages.${pkgs.system}.mango}/bin/mango";
          };
        };
      };
    }