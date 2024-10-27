{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
{

  options = {

    desktop.gtk-module.enable = lib.mkEnableOption "enable gtk";

  };

  config = lib.mkIf config.desktop.gtk-module.enable {

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
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        cursor-theme = "catppuccin-macchiato-dark-cursors";
      };
      # needed for virt-manager setup, factor this out?
      "org/virt-manager/virt-manager/connections" =
        if osConfig.libvirt.enable then
          {
            autoconnect = [ "qemu:///system" ];
            uris = [ "qemu:///system" ];
          }
        else
          { };
    };
  };
}
