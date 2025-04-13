{lib, ...}: {
  imports = [
    ./discord.nix
    ./firefox.nix
    ./zen-browser.nix
    ./overskride.nix
    ./gtk.nix
    ./nautilus.nix
    ./youtube-music.nix
    ./fuzzel.nix
    ./wlogout.nix
    ./cava.nix
    ./looking-glass-client.nix
    ./cad.nix
    ./arduino.nix
    ./obs.nix
    ./ags
    ./hypr
    ./matugen
  ];
  desktop = {
    discord.enable = lib.mkDefault false;
    overskride.enable = lib.mkDefault false;
    ytmusic.enable = lib.mkDefault false;
    ags.enable = lib.mkDefault false;
    gtk-module.enable = lib.mkDefault false;
    fuzzel.enable = lib.mkDefault false;
    wlogout.enable = lib.mkDefault false;
    matugen.enable = lib.mkDefault false;
    cava.enable = lib.mkDefault false;
    looking-glass.enable = lib.mkDefault false;
    nautilus.enable = lib.mkDefault false;
    firefox.enable = lib.mkDefault false;
    zen-browser.enable = lib.mkDefault false;
    cad.enable = lib.mkDefault false;
    arduino.enable = lib.mkDefault false;
    obs.enable = lib.mkDefault false;
  };
}
