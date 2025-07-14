{lib, ...}: {
  imports = [
    ./gtk.nix
    ./matugen
  ];
  desktop = {
    gtk-module.enable = lib.mkDefault false;
    matugen.enable = lib.mkDefault false;
  };
}
