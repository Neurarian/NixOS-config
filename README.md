# My NixOS config

Actively working on improving and expanding functionality.
Needs work on modularization and structure of the config.
So far only tailored to my notebook (Nvidia).

______________________________________________________________________

Uses the [hyprland](https://github.com/hyprwm/Hyprland) window management ecosystem. Config was mainly just copy-pasted from my Arch install and has random leftover some stuff in it that did not make it into my NixOS install yet. Uses a modified [AGS](https://github.com/Aylur/ags) setup from [fufexan](https://github.com/fufexan/dotfiles)'s config. Expands on [end-4](https://github.com/end-4/dots-hyprland)'s wallpaper-based color scheme generation using [Material colors](https://m3.material.io/styles/color/the-color-system/key-colors-tones). AGS, GTK, [fuzzel](https://codeberg.org/dnkl/fuzzel), [wlogout](https://github.com/ArtsyMacaw/wlogout), hyprland and hyprlock are dynamically themed in a matching light or dark theme depending on the wallpaper.

Custom lightweight [neovim](https://github.com/neovim/neovim) based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Uses [nixCats](https://github.com/BirdeeHub/nixCats-nvim) for plugin and dependency management and [lz.n](https://github.com/nvim-neorocks/lz.n) for plugin lazy-loading. Integrated with [tmux](https://github.com/tmux/tmux).

Setup for management of secrets with [sops-nix](https://github.com/Mic92/sops-nix)

## Other Software

<details>
  <summary>show integrated</summary>

- [zsh](https://www.zsh.org/)
- [Wezterm](https://github.com/wez/wezterm)
- custom hardened [Firefox](https://hg.mozilla.org/mozilla-central/), addons included
- [custom](https://github.com/fufexan/dotfiles) AGS bar
- [hyprspace](https://github.com/KZDKM/Hyprspace)
- [fuzzel](https://codeberg.org/dnkl/fuzzel)
- [wlogout](https://github.com/ArtsyMacaw/wlogout)
- [CAVA](https://github.com/karlstav/cava)
- Steam
- Discord
- [YouTube Music](https://github.com/th-ch/youtube-music)

</details>

<details>
  <summary>show planned</summary>

- ags widgets
- Get VFIO to work

</details>

______________________________________________________________________
