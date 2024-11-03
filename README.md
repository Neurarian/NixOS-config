# My NixOS config

Actively working on improving and expanding functionality.
Still needs work on structure/modularity of the config.

Currently running on two hosts: Medion (Intel Notebook; Nvidia GPU) & Loki (AMD Workstation; AMD GPU)

______________________________________________________________________

## ⚙️ Structure

Inspired by [Misterio77](https://github.com/Misterio77/nix-config)

- `flake.nix`: Entrypoint for all hosts.
- `hosts`: NixOS Configurations, build via `nh os switch -H <hostname>`.
  - `common`: Shared configurations imported by the host configurations.
    - `core`: Core configurations that every host requires.
    - `optional`: Optional configurations that only some hosts require
      - Optional modules are all implemented via toggleable options.
        These can easily be set for each host.
  - `Loki`: Gaming PC / Workstation - 32GB RAM, R7 5800X3D , RX 6800XT.
  - `Medion`: Notebook: Medion Erazer X7853 - 16GB RAM, i7-7700HQ, GTX 1070M.
  - `Fujitsu`: Homelab: Fujitsu Esprimo 556/2 - 32RAM, G4560T (Not running NixOS yet).
- `home`: Home Manager configuration. Via the Home Manager NixOS module.
  - `Liqyid`: Currently the only user I need. Sudoer.
    - `common`: Shared configurations imported by the user-specific host configurations.
      - `core`: Core configurations that every host running that user requires.
      - `optional`: Optional configurations that only some hosts running that user require.
        - Optional modules are all implemented via toggleable options.
          These can easily be set in each host-specific file in the user directory.

## 🖥️ Compositor & GUI

Uses the [hyprland](https://github.com/hyprwm/Hyprland) window management ecosystem. Uses a modified [AGS](https://github.com/Aylur/ags) setup from [fufexan](https://github.com/fufexan/dotfiles)'s config. Expands on [end-4](https://github.com/end-4/dots-hyprland)'s wallpaper-based color scheme generation using [Material colors](https://m3.material.io/styles/color/the-color-system/key-colors-tones). AGS, GTK, [fuzzel](https://codeberg.org/dnkl/fuzzel), [wlogout](https://github.com/ArtsyMacaw/wlogout), hyprland and hyprlock are dynamically themed in a matching light or dark theme depending on the wallpaper.

<details>
  <summary><b>Screenshots</b></summary>
  
### 🌚 Host: Medion - With dark colorscheme
![2024-11-02T21:11:34,395432515+01:00](https://github.com/user-attachments/assets/78b18a24-52f4-4581-816a-cad09019e564)
### 🌞 Host: Loki - With light colorscheme
![2024-11-02T21:53:43,163376928+01:00](https://github.com/user-attachments/assets/02743d90-af2f-47bc-a61f-30ee4277744c)


</details>

## 🧑‍💻 Neovim

Custom lightweight [neovim](https://github.com/neovim/neovim) based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Uses [nixCats](https://github.com/BirdeeHub/nixCats-nvim) for plugin and dependency management and [lz.n](https://github.com/nvim-neorocks/lz.n) for plugin lazy-loading. Integrated with [tmux](https://github.com/tmux/tmux).

### ✨ Main Features

- 🐱 [nixCats-nvim](https://github.com/BirdeeHub/nixCats-nvim) as an interface for managing installation of plugins and dependencies the Nix way, all while staying with lua for configuration.
- 🦥 Nix friendly, dead simple plugin lazy-loading with [lz.n](https://github.com/nvim-neorocks/lz.n).
- 💬 Modern and fast autocompletion with [care.nvim](https://github.com/max397574/care.nvim) & [LuaSnip](https://github.com/L3MON4D3/LuaSnip).
- 🌎 Navigation to everywhere in the project with just a couple of keypresses using [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim), [harpoon](https://github.com/ThePrimeagen/harpoon/tree/harpoon2), & the occasional [Neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim).
- 🦦 Nix friendly syntax highlighting of nix-embedded code with [otter.nvim](https://github.com/jmbuhr/otter.nvim) & [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).
- ♻️ Integration with git via [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) & [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim).
- 🔌 Running the amazing [nixd](https://github.com/nix-community/nixd) LSP via [lspconfig](https://github.com/neovim/nvim-lspconfig) making configuration a breeze.
- 🐞 Integrated debugger via [nvim-dap](https://github.com/mfussenegger/nvim-dap).
- 🎨 Harmonizing pastel aesthetics across the entire terminal via [Catppuccin](https://github.com/catppuccin/catppuccin) Dark Mocha and a pretty [alpha-nvim](https://github.com/goolord/alpha-nvim) splash screen.

## 🔒 Secret provisioning

Seamless setup for management of secrets within NixOS with [sops-nix](https://github.com/Mic92/sops-nix). Storing secrets such as Wifi creds, github tokens, SSH keys, etc. in an age encrypted .yaml file decrypted during activation time.

## 🔌 Plug & Play VFIO GPU passthrough

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

## 💿 Other Software

<details>
  <summary>Show integrated</summary>

- [zsh](https://www.zsh.org/)
- [Starship](https://github.com/starship/starship)
- [Wezterm](https://github.com/wez/wezterm)
- Colorscheme for CLI & FF: [Catppuccin Mocha](https://github.com/catppuccin/nix)
- For privacy: fully configured, custom hardened [Firefox](https://hg.mozilla.org/mozilla-central/), addons included
- For work: [Zen Browser](https://github.com/zen-browser/desktop)
- [custom](https://github.com/fufexan/dotfiles) AGS bar
- [hyprspace](https://github.com/KZDKM/Hyprspace)
- [fuzzel](https://codeberg.org/dnkl/fuzzel)
- [wlogout](https://github.com/ArtsyMacaw/wlogout)
- [CAVA](https://github.com/karlstav/cava)
- Steam
- [YouTube Music](https://github.com/th-ch/youtube-music)
- [CoolerControl](https://gitlab.com/coolercontrol/coolercontrol)

</details>

<details>
  <summary>Show planned</summary>

- Implement impermancence
- Obsidian
- AGS widgets
- Get VFIO to work properly on Notebook with Nvidia GPU (f\*\*\* them)

</details>

______________________________________________________________________
