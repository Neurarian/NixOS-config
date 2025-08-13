{lib, ...}: {
  imports = [
    ./gtk.nix
    # ./matugen
  ];
  desktop.theming = {
    gtk.enable = lib.mkDefault false;
    # matugen.enable = lib.mkDefault false;
  };
}
