{lib, ...}: {
  imports = [
    ./discord.nix
    ./firefox.nix
    ./zen-browser.nix
    ./overskride.nix
    ./mpd.nix
    ./ags/ags.nix
    ./gtk.nix
    ./nautilus.nix
    ./youtube-music.nix
    ./fuzzel.nix
    ./wlogout.nix
    ./cava.nix
    ./looking-glass-client.nix
    ./hypr
    ./cad.nix
    ./arduino.nix
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
    zen-browser.enable = lib.mkDefault false;
    cad.enable = lib.mkDefault false;
    arduino.enable = lib.mkDefault false;
  };
}
