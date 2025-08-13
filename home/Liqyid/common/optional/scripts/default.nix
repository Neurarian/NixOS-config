{lib, ...}: {
  imports = [
    ./hyprlandWrapper
  ];

  scripts = {
    hyprlandWrapper.enable = lib.mkDefault false;
  };
}
