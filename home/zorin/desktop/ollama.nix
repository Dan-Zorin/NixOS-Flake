# home/zorin/desktop/ollama.nix
{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    acceleration = "cuda";

    # Pin to your 3070 explicitly — PRIME dual-GPU setups don't reliably
    # enumerate the right device by default. Run `nvidia-smi` and replace
    # "0" with whatever index the 3070 actually shows up as.
    environmentVariables = {
      CUDA_VISIBLE_DEVICES = "0";
    };

    # Optional: pull these down automatically on activation instead of
    # `ollama pull` by hand. Remove if you'd rather manage models manually.
    loadModels = [
      "qwen2.5-coder:7b"
    ];
  };
}