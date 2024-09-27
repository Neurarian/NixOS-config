{ lib, ... }:
{
  imports = [
    ./discord.nix
    ./hyprland.nix
    ./firefox.nix
    ./catppuccin.nix
    ./overskride.nix
  ];
  discord.enable = lib.mkDefault false;
  overskride.enable = lib.mkDefault false;
}
