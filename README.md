# My NixOS config

Work in progress 🚧.

Currently running on three hosts: Medion (Intel Notebook; Nvidia GPU), Loki (AMD Workstation; AMD GPU), and WSL

______________________________________________________________________

## ⚙️ Structure

Inspired by [Misterio77], but using [flake-parts].

- `flake.nix`: Entrypoint.
- `hosts`: NixOS Configurations, rebuild via `nh os switch -H <hostname>` after bootstrapping.
  - `common`: Shared configurations imported by the host configurations.
    - `core`: Core configurations that every host requires.
    - `optional`: Optional configurations that only some hosts require
      - Optional modules are all implemented via toggleable options.
        These can easily be set for each host.
  - `Loki`: Gaming PC / Workstation - 32GB RAM, R7 5800X3D , RX 6800XT.
  - `Medion`: Notebook: Medion Erazer X7853 - 16GB RAM, i7-7700HQ, GTX 1070M.
  - `Fujitsu`: Homelab: Fujitsu Esprimo 556/2 - 32GB RAM, G4560T (Not running NixOS yet).
  - `Wsl`: Windows subsystem for Linux: Contains all core modules and mostly work related extras.
- `home`: Home Manager configuration. Via the Home Manager NixOS module.
  - `Liqyid`: Currently the only user I need. Sudoer.
    - `common`: Shared configurations imported by the user-specific host configurations.
      - `core`: Core configurations that every host running that user requires.
      - `optional`: Optional configurations that only some hosts running that user require.
        - Optional modules are all implemented via toggleable options.
          These can easily be set in each host-specific file in the user directory.
- `packages`: Place for patched binaries / packages not available in nixpkgs or dedicated flakes.
  - `saint`: Patched binary to perform "Significance Analysis of INTeractome" PMID: 24513533.
  - `python/cellpose`: A generalist algorithm for cellular segmentation (CLI only, with CUDA support) PMID: 39939718.
- `devshells`: Place for project / analysis or framework specific nix shells.
- `overlays`: Custom overlays applied to nixpkgs.
- `lib`: Nix functions and constants used in different parts of the flake.
- `formatting`: Setting formatter and pre-commit-checks for the flake.

## 🖥️ Compositor & GUI

Uses the hyprland window management ecosystem. Uses an Astal/Ags setup inspired by [fufexan]'s Agsv1 config. Wallpaper-based color scheme generation using [Material colors] via matugen and a custom rust cli utility to set light/dark theme and scheme based on main color HCT space. Astal, GTK, hyprland and hyprlock are dynamically themed in a wallpaper-matched light or dark theme.

### 📷 Screenshots

#### 🌚 Host: Medion (single monitor)

<details>
  <summary>Dark</summary>

![2024-11-02T21:11:34,395432515+01:00](https://github.com/user-attachments/assets/78b18a24-52f4-4581-816a-cad09019e564)

</details>

#### 🌞 Host: Loki - floating bar (dual monitor)

<details>
  <summary>Light</summary>

<img width="3439" height="1441" alt="2025-08-15T23:38:52,029529651+02:00" src="https://github.com/user-attachments/assets/aa5d6b14-400b-4bcf-8a2f-5b06230b75b6" />

Yeah sorry, no light terminal colors. That just hurts my eyes.

</details>

## 🧑‍💻 Neovim

Custom neovim based on [kickstart.nvim]. Uses [nixCats] for plugin and dependency management and [lze] for plugin lazy-loading. Integrated with tmux. If you want to check out just this nvim distribution run:

```bash
nix run github:Neurarian/NixOS-config#nixCats

```

But be aware that it ships all tools necessary for C, Rust, JS, and R development by default which do take up a **lot** of space. If you would like to test a more stripped down version for use with nix, lua, bash, and markdown only: try `#nixCatsStripped` instead.

### ✨ Main Features

- 🐱 [nixCats-nvim][nixcats] as an interface for managing installation of plugins and dependencies the Nix way, all while staying with lua for configuration.
- 🦥 Nix friendly, dead simple plugin lazy-loading with [lze].
- 💬 Modern and fast autocompletion with [blink.cmp] & [LuaSnip].
- 🌎 Navigation to everywhere in the project with just a couple of keypresses using the [snacks.nvim] picker.
- 🦦 Nix friendly syntax highlighting of nix-embedded code with [otter.nvim] & [nvim-treesitter].
- ♻️ Integration with git via [lazygit.nvim] & [gitsigns.nvim].
- 🔌 Running the amazing [nixd] LSP, making configuration a breeze.
- 🐞 Integrated debugger via [nvim-dap].
- 🎨 Harmonizing pastel aesthetics across the entire terminal via [Catppuccin] Dark Mocha and a pretty [snacks.nvim] dashboard.

## 🔒 Secret Provisioning

Seamless setup for management of secrets within NixOS with [sops-nix]. Storing secrets such as wifi creds, github tokens, SSH keys, etc. in an age encrypted .yaml file decrypted during activation time.

## 🔌 Plug & Play VFIO GPU Passthrough

Includes a [custom NixOS module] that generates a single-file qemu hook making (single) GPU passthrough via detaching and reattaching of the respective kernel drivers on NixOS dead simple, e.g.:

```nix
#hosts/<hostname>/default.nix
{
  inputs,
  ...
}:
#...
{
  imports = [
    #...
    ../common/optional
    #...
  ];
  #...
  # VFIO: single GPU passthrough for 6800XT
  libvirt = {
    enable = true;
    qemuHook = {
      enable = true;
      vmName = "win10";
      pciDevices = [
        "pci_0000_0b_00_0"
        "pci_0000_0b_00_1"
        "pci_0000_0b_00_2"
      ];
      gpuModule = "amdgpu";
      vfioModule = "vfio-pci";
    };
  };
}

```

## 💿 Software List

<div align="center">

| Type | Software |
| --------------- | --------------- |
| **Window Manager** | [hyprland] |
| **Bar** | [Astal] |
| **App Launcher** | [Astal] |
| **Resource Monitor** | [resources] & [CoolerControl] |
| **File Manager** | [nautilus] |
| **Lockscreen** | [hyprlock] |
| **Logout Menu** | [Astal] |
| **Browser** | [custom hardened Firefox] & [Zen] |
| **Media Player** | [mpd] & [Astal] & [Pear] |
| **Gaming** | [Steam / Gamescope] |
| **Screenshot Software** | [grimblast] |
| **Clipboard** | [wl-clipboard] & [cliphist] |
| **Terminal Emulator** | [WezTerm] |
| **Terminal Multiplexer** | [tmux] |
| **Shell** | [zsh] & [Starship] |
| **Editor** | [neovim] |
| **Secret Provisioning** | [sops-nix] |
| **Fonts** | [Jetbrains Mono] & [FiraCode] |
| **Color Scheme** | [Catppuccin Mocha] & [matugen] |
| **Cursor** | [Catppuccin-Macchiato-Dark] |

</div>

<details>
  <summary>Show planned</summary>

<div align="center">

| Type | Software |
| --------------- | --------------- |
| **Ephemeral Root Storage** | [Impermanence] |
| **Notes** | [Obsidian] |
| **VFIO** | Does not work on Notebook Nvidia GPU yet |

</div>

</details>

______________________________________________________________________

[astal]: https://github.com/Aylur/astal
[blink.cmp]: https://github.com/Saghen/blink.cmp
[catppuccin]: https://github.com/catppuccin/catppuccin
[catppuccin mocha]: https://github.com/catppuccin/nix
[catppuccin-macchiato-dark]: https://github.com/catppuccin/cursors
[cliphist]: https://github.com/sentriz/cliphist
[coolercontrol]: https://gitlab.com/coolercontrol/coolercontrol
[custom hardened firefox]: https://hg.mozilla.org/mozilla-central/
[custom nixos module]: https://github.com/Neurarian/NixOS-config/blob/master/hosts/common/optional/libvirt.nix
[firacode]: https://github.com/tonsky/FiraCode
[flake-parts]: https://github.com/hercules-ci/flake-parts
[fufexan]: https://github.com/fufexan/dotfiles
[gitsigns.nvim]: https://github.com/lewis6991/gitsigns.nvim
[grimblast]: https://github.com/hyprwm/contrib/tree/main/grimblast
[hyprland]: https://github.com/hyprwm/Hyprland
[hyprlock]: https://github.com/hyprwm/hyprlock/
[impermanence]: https://github.com/nix-community/impermanence
[jetbrains mono]: https://www.jetbrains.com/lp/mono/
[kickstart.nvim]: https://github.com/nvim-lua/kickstart.nvim
[lazygit.nvim]: https://github.com/kdheepak/lazygit.nvim
[luasnip]: https://github.com/L3MON4D3/LuaSnip
[lze]: https://github.com/BirdeeHub/lze
[material colors]: https://m3.material.io/styles/color/the-color-system/key-colors-tones
[matugen]: https://github.com/InioX/matugen
[misterio77]: https://github.com/Misterio77/nix-config
[mpd]: https://github.com/MusicPlayerDaemon/MPD
[nautilus]: https://gitlab.gnome.org/GNOME/nautilus
[neovim]: https://github.com/neovim/neovim
[nixcats]: https://github.com/BirdeeHub/nixCats-nvim
[nixd]: https://github.com/nix-community/nixd
[nvim-dap]: https://github.com/mfussenegger/nvim-dap
[nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[obsidian]: https://obsidian.md/
[otter.nvim]: https://github.com/jmbuhr/otter.nvim
[pear]: https://github.com/-ch/youtube-music
[resources]: https://github.com/nokyan/resources
[snacks.nvim]: https://github.com/folke/snacks.nvim
[sops-nix]: https://github.com/Mic92/sops-nix
[starship]: https://github.com/starship/starship
[steam / gamescope]: https://github.com/ValveSoftware/gamescope
[tmux]: https://github.com/tmux/tmux
[wezterm]: https://github.com/wez/wezterm
[wl-clipboard]: https://github.com/bugaevc/wl-clipboard
[zen]: https://github.com/zen-browser/desktop
[zsh]: https://www.zsh.org/
