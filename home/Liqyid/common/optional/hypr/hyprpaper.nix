{
  config,
  lib,
  ...
}:
{
  options = {
    desktop.hypr.hyprpaper.enable = lib.mkEnableOption "enable hyprpaper";
  };

  config = lib.mkIf config.desktop.hypr.hyprpaper.enable {

    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload = [ "$HOME/.cache/current_wallpaper.jpg" ];

        wallpaper = [
          #TODO: This is not common!
          "eDP-1, $HOME/.cache/current_wallpaper.jpg"
        ];
      };
    };
  };
}
