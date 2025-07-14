{lib, ...}: {
  imports = [
    ./mpd.nix
    ./polkit.nix
    ./power-monitor.nix
  ];
  power_monitor.enable = lib.mkDefault false;
  polkit_gnome.enable = lib.mkDefault false;
  mpd.enable = lib.mkDefault false;
}
