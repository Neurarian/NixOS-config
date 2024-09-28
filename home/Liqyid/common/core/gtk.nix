{
  pkgs,
  config,
  ...
}:
{
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

}
