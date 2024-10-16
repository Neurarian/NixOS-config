{ lib, ... }:
{
  imports = [
    ./discord.nix
    ./firefox.nix
    ./overskride.nix
    ./mpd.nix
    ./ags.nix
    ./gtk.nix
    ./youtube-music.nix
    ./services
    ./fuzzel.nix
    ./wlogout.nix
    ./cava.nix
    ./looking-glass-client.nix
    ./hypr
  ];
  discord.enable = lib.mkDefault false;
  overskride.enable = lib.mkDefault false;
  ytmusic.enable = lib.mkDefault false;
  mpd.enable = lib.mkDefault false;
  ags.enable = lib.mkDefault true;
  gtk_module.enable = lib.mkDefault true;
  fuzzel.enable = lib.mkDefault false;
  wlogout.enable = lib.mkDefault false;
  cava.enable = lib.mkDefault false;
  looking-glass.enable = lib.mkDefault false;
}
