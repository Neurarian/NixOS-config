{lib, ...}: {
  imports = [
    ./backlight.nix
    ./virsh_netstart.nix
    ./vfio_gpu_power_management.nix
    ./actkbd.nix
  ];
  backlight.enable = lib.mkDefault false;
  virsh_netstart_service.enable = lib.mkDefault false;
  gpu_power_management.enable = lib.mkDefault false;
  actkbd.enable = lib.mkDefault false;
}
