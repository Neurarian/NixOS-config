{lib, ...}: {
  imports = [
    ./services
    ./localsend.nix
  ];
  networking.localsend.enable = lib.mkDefault false;
}
