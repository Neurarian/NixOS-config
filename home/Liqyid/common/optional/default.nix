{ lib, ... }:
{
  imports = [
    ./discord.nix
    ./hyprland.nix
    ./firefox.nix
    ./catppuccin.nix
    ./overskride.nix
    ./youtube-music.nix
  ];
  discord.enable = lib.mkDefault false;
  overskride.enable = lib.mkDefault false;
  ytmusic.enable = lib.mkDefault false;
}
