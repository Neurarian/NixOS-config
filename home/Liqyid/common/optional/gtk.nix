{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {

    gtk_module.enable = lib.mkEnableOption "enable gtk";

  };

  config = lib.mkIf config.gtk_module.enable {

    home.packages = [ pkgs.dconf ];

    gtk = {

      enable = true;

      font = {
        name = "JetBrainsMono";
        package = pkgs.jetbrains-mono;
        size = 9;
      };

      # gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };
  };

}
