{lib, ...}: {
  imports = [
    ./ssh.nix
    ./wifi.nix
  ];
  networking.services = {
    ssh.enable = lib.mkDefault false;
    wifi.enable = lib.mkDefault false;
  };
}
