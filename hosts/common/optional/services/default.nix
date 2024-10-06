{ lib, ... }:
{
  imports = [
    ./backlight.nix
    ./virsh_netstart.nix
  ];
  backlight.enable = lib.mkDefault false;
  virsh_netstart_service.enable = lib.mkDefault false;
}
