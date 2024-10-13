{ lib, ... }:
{
  imports = [
    ./nvidia.nix
    ./localsend.nix
    ./services
    ./powermanagement.nix
    ./vfio_nvidia_intel.nix
    ./libvirt.nix
  ];
  localsend.enable = lib.mkDefault false;
  powermanagement.enable = lib.mkDefault false;
  libvirt.enable = lib.mkDefault false;
}
