{ lib, ... }:
{
  imports = [
    ./backlight.nix
  ];
  backlight.enable = lib.mkDefault false;
}
