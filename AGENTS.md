# AGENTS.md

## Rebuild / verify
- `sudo nixos-rebuild switch --flake .#zorin` — apply changes
- `home-manager build --flake .#zorin` or `nixos-rebuild build --flake .#zorin --no-link` — dry-run before switching; catches bad option paths without touching the running system
- `manix "<term>"` — look up real NixOS/home-manager option names before writing config that uses them

## Structure
- Flakes-based, `nixpkgs` pinned to `nixos-26.05`; `nixpkgs-2511` (25.11) kept as a second input for packages removed from mainline (e.g. DuckStation)
- home-manager is wired in as a NixOS module inside `nixosConfigurations.zorin`, not used standalone — `home-manager.users.zorin` lives there
- `home-manager.extraSpecialArgs = { inherit inputs; }` is required for any `home/zorin/Nix/**.nix` file that needs a flake input
- System modules: `hosts/zorin/modules/`
- Home-manager modules: `home/zorin/`, split further by concern (e.g. `home/zorin/desktop/`)

## Critical: namespace separation
NixOS system-level options and home-manager options are different schemas even when named identically. Never assume an option that exists at one level exists at the other. Always verify with `manix` or a dry build before asserting an option exists.

## Conventions
- Small, scoped modules — one concern per file
- Prefer explicit, local settings over broad global flags
- Confirm and build incrementally rather than batching large rewrites

## Known gotchas in this repo
- `pkgs.ollama` is CPU-only by default on NixOS — needs `acceleration = "cuda"` or `package = pkgs.ollama-cuda`
- OpenClaw's official module is `programs.openclaw` — `services.openclaw` is a different, unofficial flake