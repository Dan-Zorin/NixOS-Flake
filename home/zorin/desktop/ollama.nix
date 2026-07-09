# home/zorin/desktop/ollama.nix
{ pkgs, lib, ... }:
{
  services.ollama = {
    enable = true;
    acceleration = "cuda";

    # Pin to your 3070 explicitly — confirm the index with `nvidia-smi`
    environmentVariables = {
      CUDA_VISIBLE_DEVICES = "0";
    };
  };

    systemd.user.services.ollama.Install.WantedBy = lib.mkForce [ ];

}