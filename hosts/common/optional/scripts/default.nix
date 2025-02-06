{lib, ...}: {
  imports = [
    ./gamescope.nix
  ];

  scripts = {
    gamescope.enable = lib.mkDefault false;
  };
}
