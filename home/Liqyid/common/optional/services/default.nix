{ lib, ... }:
{
  imports = [
    ./power-monitor.nix
  ];
  power_monitor.enable = lib.mkDefault false;
}
