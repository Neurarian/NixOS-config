{ lib, ... }:
{
  imports = [
    ./discord.nix
    ./firefox.nix
    ./overskride.nix
    ./mpd.nix
    ./ags.nix
    ./gtk.nix
    ./nautilus.nix
    ./youtube-music.nix
    ./fuzzel.nix
    ./wlogout.nix
    ./cava.nix
    ./looking-glass-client.nix
    ./hypr
  ];
  desktop = {
    discord.enable = lib.mkDefault false;
    overskride.enable = lib.mkDefault false;
    ytmusic.enable = lib.mkDefault false;
    mpd.enable = lib.mkDefault false;
    ags.enable = lib.mkDefault false;
    gtk-module.enable = lib.mkDefault false;
    fuzzel.enable = lib.mkDefault false;
    wlogout.enable = lib.mkDefault false;
    cava.enable = lib.mkDefault false;
    looking-glass.enable = lib.mkDefault false;
    nautilus.enable = lib.mkDefault false;
    firefox.enable = lib.mkDefault false;
  };
}
