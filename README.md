# My NixOS config

Work in progress 🚧.

Currently running on three hosts: Medion (Intel Notebook; Nvidia GPU), Loki (AMD Workstation; AMD GPU), and WSL

______________________________________________________________________

## ⚙️ Structure

Inspired by [Misterio77](https://github.com/Misterio77/nix-config)

- `flake.nix`: Entrypoint for all hosts.
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
  - `R/nvimcom`: R package allowing nvim <-> R communication. Used in my nvim config.
- `devshells`: Place for project / analysis or framework specific nix shells.

## 🖥️ Compositor & GUI

Uses the hyprland window management ecosystem. Uses an Astal/Ags setup inspired by [fufexan](https://github.com/fufexan/dotfiles)'s Agsv1 config. Wallpaper-based color scheme generation using [Material colors](https://m3.material.io/styles/color/the-color-system/key-colors-tones) via matugen and a custom rust cli utility to set light/dark theme and scheme based on main color HCT space. Astal, GTK, hyprland and hyprlock are dynamically themed in a wallpaper-matched light or dark theme.

### 📷 Screenshots

#### 🌚 Host: Medion - With dark colorscheme (single monitor)

![2024-11-02T21:11:34,395432515+01:00](https://github.com/user-attachments/assets/78b18a24-52f4-4581-816a-cad09019e564)

#### 🌞 Host: Loki - With light colorscheme (dual monitor)

![2024-11-02T21:53:43,163376928+01:00](https://github.com/user-attachments/assets/02743d90-af2f-47bc-a61f-30ee4277744c)

## 🧑‍💻 Neovim

Custom neovim based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Uses [nixCats](https://github.com/BirdeeHub/nixCats-nvim) for plugin and dependency management and [lze](https://github.com/BirdeeHub/lze) for plugin lazy-loading. Integrated with tmux. If you want to check out just this nvim distribution run:

```bash
nix run github:Neurarian/NixOS-config#nixCats

```

But be aware that it ships all tools necessary for C, Rust, JS, and R development by default which do take up a **lot** of space. If you would like to test a more stripped down version for use with nix, lua, bash, and markdown only: try `#nixCatsStripped` instead.

### ✨ Main Features

- 🐱 [nixCats-nvim](https://github.com/BirdeeHub/nixCats-nvim) as an interface for managing installation of plugins and dependencies the Nix way, all while staying with lua for configuration.
- 🦥 Nix friendly, dead simple plugin lazy-loading with [lze](https://github.com/BirdeeHub/lze).
- 💬 Modern and fast autocompletion with [care.nvim](https://github.com/max397574/care.nvim) & [LuaSnip](https://github.com/L3MON4D3/LuaSnip).
- 🌎 Navigation to everywhere in the project with just a couple of keypresses using [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim), [harpoon](https://github.com/ThePrimeagen/harpoon/tree/harpoon2), & the occasional [Neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim).
- 🦦 Nix friendly syntax highlighting of nix-embedded code with [otter.nvim](https://github.com/jmbuhr/otter.nvim) & [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).
- ♻️ Integration with git via [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) & [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim).
- 🔌 Running the amazing [nixd](https://github.com/nix-community/nixd) LSP via [lspconfig](https://github.com/neovim/nvim-lspconfig) making configuration a breeze.
- 🐞 Integrated debugger via [nvim-dap](https://github.com/mfussenegger/nvim-dap).
- 🎨 Harmonizing pastel aesthetics across the entire terminal via [Catppuccin](https://github.com/catppuccin/catppuccin) Dark Mocha and a pretty [alpha-nvim](https://github.com/goolord/alpha-nvim) splash screen.

## 🔒 Secret Provisioning

Seamless setup for management of secrets within NixOS with [sops-nix](https://github.com/Mic92/sops-nix). Storing secrets such as wifi creds, github tokens, SSH keys, etc. in an age encrypted .yaml file decrypted during activation time.

## 🔌 Plug & Play VFIO GPU Passthrough

Includes a [custom NixOS module](https://github.com/Neurarian/NixOS-config/blob/master/hosts/common/optional/libvirt.nix) that generates a single-file qemu hook making (single) GPU passthrough via detaching and reattaching of the respective kernel drivers on NixOS dead simple, e.g.:

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
| ------------------------ | :---------------------------------------------------------------------------------------------:
| **Window Manager** | [hyprland](https://github.com/hyprwm/Hyprland) + [hyprspace](https://github.com/KZDKM/Hyprspace) |
| **Bar** | [Astal](https://github.com/Aylur/astal) |
| **App Launcher** | [Astal](https://github.com/Aylur/astal) |
| **Resource Monitor** | [Mission Center](https://gitlab.com/mission-center-devs/mission-center) + [CoolerControl](https://gitlab.com/coolercontrol/coolercontrol)|
| **File Manager** | [nautilus](https://gitlab.gnome.org/GNOME/nautilus) |
| **Lockscreen** | [hyprlock](https://github.com/hyprwm/hyprlock/) |
| **Logout Menu** | [Astal](https://github.com/Aylur/astal) |
| **Browser** | [custom hardened Firefox](https://hg.mozilla.org/mozilla-central/) + [Zen](https://github.com/zen-browser/desktop) |
| **Media Player** | [mpd](https://github.com/MusicPlayerDaemon/MPD) + [Astal](https://github.com/Aylur/astal) + [YouTube Music](https://github.com/th-ch/youtube-music) |
| **Gaming** | [Steam / Gamescope](https://github.com/ValveSoftware/gamescope) |
| **Screenshot Software** | [grimblast](https://github.com/hyprwm/contrib/tree/main/grimblast) |
| **Clipboard** | [wl-clipboard](https://github.com/bugaevc/wl-clipboard) + [cliphist](https://github.com/sentriz/cliphist) |\
| **Terminal Emulator** | [WezTerm](https://github.com/wez/wezterm) |
| **Terminal Multiplexer** | [tmux](https://github.com/tmux/tmux) |
| **Shell** | [zsh](https://www.zsh.org/) + [Starship](https://github.com/starship/starship) |
| **Editor** | [neovim](https://github.com/neovim/neovim) |
| **Secret Provisioning** | [sops-nix](https://github.com/Mic92/sops-nix) |
| **Fonts** | [Jetbrains Mono](https://www.jetbrains.com/lp/mono/) + [FiraCode](https://github.com/tonsky/FiraCode) |
| **Color Scheme** | [Catppuccin Mocha](https://github.com/catppuccin/nix) + [matugen](https://github.com/InioX/matugen) |
| **Cursor** | [Catppuccin-Macchiato-Dark](https://github.com/catppuccin/cursors) |

</div>

<details>
  <summary>Show planned</summary>

<div align="center">

| Type | Software |
| --------------------------- | :---------------------------------------------------------------------------------------------:
| **Ephemeral Root Storage** | [Impermanence](https://github.com/nix-community/impermanence) |
| **Notes** | [Obsidian](https://obsidian.md/) |
| **Bar & Widgets** | [Migrate to AGS v2](https://github.com/Aylur/ags) |
| **VFIO** | Does not work on Notebook Nvidia GPU yet |

</div>

</details>

______________________________________________________________________
