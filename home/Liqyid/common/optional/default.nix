{ lib, ... }:
{
  imports = [
    ./discord.nix
    ./hyprland.nix
    ./firefox.nix
    ./catppuccin.nix
    ./overskride.nix
    ./cli-visualizer.nix
    ./mpd.nix
    ./ags.nix
    ./gtk.nix
    ./youtube-music.nix
    ./services
    ./fuzzel.nix
  ];
  discord.enable = lib.mkDefault false;
  overskride.enable = lib.mkDefault false;
  ytmusic.enable = lib.mkDefault false;
  clivis.enable = lib.mkDefault false;
  mpd.enable = lib.mkDefault false;
  ags.enable = lib.mkDefault true;
  gtk_module.enable = lib.mkDefault true;
  fuzzel.enable = lib.mkDefault false;
}
