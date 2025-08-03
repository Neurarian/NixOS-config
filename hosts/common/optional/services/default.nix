{lib, ...}: {
  imports = [
    ./actkbd.nix
    ./backlight.nix
    ./ssh.nix
    ./vfio_gpu_power_management.nix
    ./virsh_netstart.nix
  ];
  homessh.enable = lib.mkDefault false;
  backlight.enable = lib.mkDefault false;
  virsh_netstart_service.enable = lib.mkDefault false;
  gpu_power_management.enable = lib.mkDefault false;
  actkbd.enable = lib.mkDefault false;
}
