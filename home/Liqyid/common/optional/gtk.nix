{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {

    gtk-module.enable = lib.mkEnableOption "enable gtk";

  };

  config = lib.mkIf config.gtk-module.enable {

    gtk = {

      enable = true;

      font = {
        package = pkgs.fira-code;
        name = "FiraCode";
        size = 9;
      };

      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
    };

    # Set GTK cursor-theme
    # TODO: Make this work with $HYPRCURSOR_THEME env var
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        cursor-theme = "catppuccin-macchiato-dark-cursors";
      };
    # needed for virt-manager setup, factor this out?
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
}
