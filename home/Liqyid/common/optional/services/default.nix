{lib, ...}: {
  imports = [
    ./power-monitor.nix
    ./polkit.nix
  ];
  power_monitor.enable = lib.mkDefault false;
  polkit_gnome.enable = lib.mkDefault false;
}
