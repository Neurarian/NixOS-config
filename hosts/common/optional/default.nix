{ lib, ... }:
{
  imports = [
    ./nvidia.nix
    ./localsend.nix
    ./services
  ];
  localsend.enable = lib.mkDefault false;
}
