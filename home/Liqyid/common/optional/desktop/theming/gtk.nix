{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: {
  options = {
    desktop.theming.gtk.enable = lib.mkEnableOption "enable & theme gtk";
  };

  config = lib.mkIf config.desktop.theming.gtk.enable {
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
        if osConfig.virtualisation.libvirt.enable
        then {
          autoconnect = ["qemu:///system"];
          uris = ["qemu:///system"];
        }
        else {};
    };
  };
}
