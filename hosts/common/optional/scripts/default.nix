{lib, ...}: {
  imports = [
    ./gamescope.nix
  ];

  scripts = {
    gamescopewm.enable = lib.mkDefault false;
  };
}
