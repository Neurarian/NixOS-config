{lib, ...}: {
  imports = [
    ./boot.nix
    ./nvidia.nix
    ./localsend.nix
    ./powermanagement.nix
    ./libvirt.nix
    ./coolercontrol.nix
    ./hyprsys.nix
    ./gaming.nix
    ./services
    ./scripts
    ./desktop.nix
  ];
  # This module should only be disabled for WSL
  bmboot.enable = lib.mkDefault true;

  localsend.enable = lib.mkDefault false;
  coolercontrol.enable = lib.mkDefault false;
  powermanagement.enable = lib.mkDefault false;
  libvirt.enable = lib.mkDefault false;
  hyprsys.enable = lib.mkDefault false;
  gaming.enable = lib.mkDefault false;
  desktop.services.enable = lib.mkDefault false;
}
