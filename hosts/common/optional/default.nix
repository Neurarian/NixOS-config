{ lib, ... }:
{
  imports = [
    ./nvidia.nix
    ./localsend.nix
    ./services
    ./powermanagement.nix
    ./libvirt.nix
    ./coolercontrol.nix
    ./hyprsys.nix
    ./gaming.nix
  ];
  localsend.enable = lib.mkDefault false;
  coolercontrol.enable = lib.mkDefault false;
  powermanagement.enable = lib.mkDefault false;
  libvirt.enable = lib.mkDefault false;
  hyprsys.enable = lib.mkDefault false;
  gaming.enable = lib.mkDefault false;
}
