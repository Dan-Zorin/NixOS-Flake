<div align='center'>
    <h1><b>🚀 DOTFILES 🚀</b></h1>
    <img src='https://brand.nixos.org/logos/nixos-logo-black-flat-black-regular-horizontal-recommended.svg' width='250' height='250' />
    <p>Nord Themed MangoWC on NixOS</p>

![Size](https://img.shields.io/github/languages/code-size/Dan-Zorin/NixOS-Flake.svg)
![License](https://img.shields.io/github/license/Dan-Zorin/NixOS-Flake.svg)

</div>

---

##  **ABOUT**

**Declarative Workstation** built entirely on NixOS flakes + home-manager.
No Hyprland, no Qtile — this rig runs **MangoWC**, a dwl-based wlroots
compositor, themed Nord-on-Nord via Stylix and pywal16, with a
**Quickshell** desktop UI on top.

Everything below is config, not clicked — the goal is a system that can be
rebuilt from a single `flake.lock` on new hardware in one command.

<br />

---

##  **SHOWCASE**

<img src="https://imgur.com/5uhcsL2.png">

<br />

---

##  **STACK**

| Component        | Choice                          | Notes                                                        |
|-------------------|----------------------------------|----------------------------------------------------------------|
| OS                | NixOS (`nixos-26.05`, "Yarara")  | secondary `nixpkgs-2511` input for removed packages            |
| Compositor        | MangoWC (dwl-based, wlroots)     | replaced Hyprland entirely                                     |
| Shell / Bar       | Quickshell (`shell.qml`)         | QML-based desktop UI                                           |
| Theming           | Stylix + pywal16 + swww          | Nord scheme; pywal drives dynamic wallpaper-based accents       |
| Notifications     | dunst                            | not Quickshell-native, kept standalone                         |
| Display Manager   | greetd + tuigreet                | migrated off SDDM to fix mouse input on session exit           |
| Terminal Mux      | tmux (home-manager, declarative) | plugins managed declaratively, TPM removed                     |
| Bootloader        | systemd-boot                     | via Lanzaboote, for Secure Boot compatibility                  |
| Discord           | Vesktop                          | `VENCORD_USER_DATA_DIR` workaround for read-only Nix store      |

<br />

---

##  **HARDWARE**

- **CPU:** Intel i9-7920X (12C/24T, overclocked)
- **GPU:** RTX 3070 (single-GPU, handles display + compute)
- **RAM:** 64GB SK Hynix HMA81GU6AFR8N-UH (A-die)
- **Storage:** Multi-disk NVMe/SSD, BTRFS + zstd compression
- **TPM:** 2.0, functional (`/dev/tpm0`, `/dev/tpmrm0`) — measured boot / LUKS auto-unlock still a work in progress

<br />

---

##  **STRUCTURE**

```
.
├── flake.nix                 # entry point, inputs, specialArgs (shared `vars`)
├── flake.lock
├── hosts/
│   └── <hostname>/
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── modules/
│   ├── nixos/
│   │   ├── boot.nix           # systemd-boot / Lanzaboote
│   │   ├── greetd.nix         # misnamed sddm.nix historically — greetd/tuigreet now
│   │   ├── jellyfin.nix       # nginx reverse proxy + Let's Encrypt
│   │   └── portainer.nix
│   └── home-manager/
│       ├── mangowc/
│       │   └── default.nix
│       ├── quickshell/
│       │   ├── shell.qml
│       │   └── colors.qml     # pywal template, consumed by Quickshell
│       ├── stylix.nix
│       ├── dunst.nix
│       ├── tmux.nix
│       └── wallpaper/
│           └── set-wallpaper  # swww + wal -i
└── AGENTS.md                  # flake structure + NixOS vs home-manager conventions
```

<br />

---

##  **QUICK START**

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git
cd dotfiles

# apply to a defined host
sudo nixos-rebuild switch --flake .#<hostname>

# home-manager only
home-manager switch --flake .#<user>@<hostname>
```

<br />

---

##  **THEMING NOTES**

- Stylix still drives most global theming, but the **GTK target was handed
  off to pywal16** so wallpaper changes can re-derive the whole palette.
- `set-wallpaper` runs `awww img <path>` followed by `wal -i <path>`, then
  Quickshell picks up the regenerated `colors.qml` template on the next
  shell reload.
- Notifications stay on dunst rather than a Quickshell notification
  center — kept deliberately separate for now.

<br />

---

##  **KNOWN QUIRKS / FIXES**

- **KDE Connect** links failed browser detection via `kdeconnectd` — fixed
  by setting `BROWSER = "vivaldi-stable";` in `home.sessionVariables`.
- **DuckStation + MangoHud** crashed over a libdbus version mismatch on
  NixOS — traced, not yet fully resolved upstream.
- **UWSM** had four overlapping launch mechanisms left over from the
  Hyprland era — being consolidated as part of the flake overhaul.
- Kernel: dropped **xanmod** after NVIDIA 595.x drivers broke against the
  6.15+ kernel API.

<br />

---

##  **HISTORY**

- Hyprland → **MangoWC** (full compositor swap, config format changed
  from `.lua` to Nix/QML-driven)
- SDDM → **greetd/tuigreet** (mouse input bug on session exit)
- NixOS 25.11 → 26.05 ("Yarara")
- systemd-boot → GRUB → **systemd-boot** (settled on Lanzaboote for
  Secure Boot)

<br />

---

<div align="center">
<sub>Built on <a href="https://nixos.org">NixOS</a> — Nord theme throughout.</sub>
</div>
