{lib, ...}: {
  imports = [
    ./services
    ./desktop
    ./scripts
    ./mpd.nix
  ];
  mpd.enable = lib.mkDefault false;
}
