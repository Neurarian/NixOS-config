{lib, ...}: {
  imports = [
    ./boot.nix
    ./services
  ];

  hardware = {
    bmboot.enable = lib.mkDefault true;
  };
}
