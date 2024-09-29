{ lib, ... }:
{
  imports = [
    ./nvidia.nix
  ];
  graphics_erazer.enable = lib.mkDefault false;
}
