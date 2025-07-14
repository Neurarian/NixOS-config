{lib, ...}: {
  imports = [
    ./arduino.nix
  ];
  desktop.development = {
    arduino.enable = lib.mkDefault false;
  };
}
