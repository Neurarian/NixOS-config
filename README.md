
# My NixOS config
### Actively working on improving and expanding functionality
### Needs work on modularization and structure of the config
### So far only tailored to my notebook (Nvidia)
---

## Window Manager 

Uses the [hyprland](https://github.com/hyprwm/Hyprland) window management ecosystem. Config was mainly just copy-pasted from my Arch install and has random leftover some stuff in it that did not make it into my NixOS install yet.

## "Nixus" Editor

Custom lightweight [neovim](https://github.com/neovim/neovim) based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Uses [nixCats](https://github.com/BirdeeHub/nixCats-nvim) for package and dependency management and [lz.n](https://github.com/nvim-neorocks/lz.n) for plugin lazy-loading integrated with [tmux](https://github.com/tmux/tmux).

## Secret Provisioning

Setup for management of secrets with [sops-nix](https://github.com/Mic92/sops-nix)

## Other Software

<details>
  <summary>show integrated</summary>

  - [zsh](https://www.zsh.org/)
  - [kitty](https://github.com/kovidgoyal/kitty)
  - custom hardened [Firefox](https://hg.mozilla.org/mozilla-central/), addons included
  - Steam
  - Discord

</details>

<details>
  <summary>show planned</summary>
  
  - create $user variable in flake and inherit
  - setup bluetooth
  - [YouTube Music](https://github.com/th-ch/youtube-music)
  - [custom](https://github.com/Neurarian/ags-bar) [ags](https://github.com/Aylur/ags) bar
  - ags widgets
  - write config in pure nix
  - switch to [Wezterm](https://github.com/wez/wezterm)?

</details>

---
