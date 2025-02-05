{lib, ...}: {
  imports = [
    ./hyprlandWrapper
    ./colorgen
  ];

  scripts = {
    hyprlandWrapper.enable = lib.mkDefault false;
    wallpaperColorgen.enable = lib.mkDefault false;
  };
}
