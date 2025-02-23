{
  lib,
  ...
}: {
  imports = [
    ./hyprlandWrapper
    ./wal_set.nix
  ];

  scripts = {
    hyprlandWrapper.enable = lib.mkDefault false;
    wallpaperSetter.enable = lib.mkDefault false;
  };

}
