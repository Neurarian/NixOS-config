{ lib, ... }:
{
  imports = [
    ./polkit.nix
  ];
  polkit_gnome.enable = lib.mkDefault true;
}
