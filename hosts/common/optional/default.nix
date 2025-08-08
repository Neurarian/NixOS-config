{lib, ...}: {
  imports = [
    ./gaming
    ./hardware
    ./networking
    ./virtualisation
    ./desktop.nix
  ];

  desktop.enable = lib.mkDefault false;
}
