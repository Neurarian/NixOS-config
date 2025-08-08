{lib, ...}: {
  imports = [
    ./actkbd.nix
    ./backlight.nix
    ./gpuPowerManagement.nix
    ./powermanagement.nix
    ./coolercontrol.nix
  ];
  hardware.services = {
    actkbd.enable = lib.mkDefault false;
    backlight.enable = lib.mkDefault false;
    gpuPowerManagement.disable = lib.mkDefault false;
    powermanagement.enable = lib.mkDefault false;
    coolercontrol.enable = lib.mkDefault false;
  };
}
