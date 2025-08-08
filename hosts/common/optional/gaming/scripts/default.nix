{lib, ...}: {
  imports = [
    ./gamescope.nix
  ];

  gaming.scripts = {
    gamescope.enable = lib.mkDefault false;
  };
}
