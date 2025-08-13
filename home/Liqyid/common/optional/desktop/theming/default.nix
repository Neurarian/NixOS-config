{lib, ...}: {
  imports = [
    ./gtk.nix
  ];
  desktop.theming = {
    gtk.enable = lib.mkDefault false;
  };
}
