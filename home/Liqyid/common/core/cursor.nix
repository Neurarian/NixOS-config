{pkgs, ...}: {
  home.pointerCursor = {
    enable = true;
    package = pkgs.catppuccin-cursors.macchiatoDark;
    name = "Catppuccin-Macchiato-Dark-Cursors";
    size = 24;
  };
}
