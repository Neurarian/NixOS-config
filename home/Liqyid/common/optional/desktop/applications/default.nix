{lib, ...}: {
  imports = [
    ./ags
    ./cad.nix
    ./cava.nix
    ./discord.nix
    ./firefox.nix
    ./fuzzel.nix
    ./gnome-control-center.nix
    ./looking-glass-client.nix
    ./mumble.nix
    ./nautilus.nix
    ./obs.nix
    ./overskride.nix
    ./oversteer.nix
    ./resources.nix
    ./wlogout.nix
    ./youtube-music.nix
    ./zen-browser.nix
    ./zotero.nix
  ];
  desktop.applications = {
    ags.enable = lib.mkDefault false;
    cad.enable = lib.mkDefault false;
    cava.enable = lib.mkDefault false;
    discord.enable = lib.mkDefault false;
    firefox.enable = lib.mkDefault false;
    fuzzel.enable = lib.mkDefault false;
    gnome-control-center.enable = lib.mkDefault false;
    looking-glass.enable = lib.mkDefault false;
    mumble.enable = lib.mkDefault false;
    nautilus.enable = lib.mkDefault false;
    obs.enable = lib.mkDefault false;
    overskride.enable = lib.mkDefault false;
    oversteer.enable = lib.mkDefault false;
    resources.enable = lib.mkDefault false;
    wlogout.enable = lib.mkDefault false;
    ytmusic.enable = lib.mkDefault false;
    zen-browser.enable = lib.mkDefault false;
    zotero.enable = lib.mkDefault false;
  };
}
