{lib, ...}: {
  imports = [
    ./libvirt.nix
    ./services
  ];

  virtualisation.libvirt.enable = lib.mkDefault false;
}
