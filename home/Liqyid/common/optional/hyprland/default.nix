{
  config,
  lib,
  ...
}:
{
  imports = [
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
  ];

  options = {
    desktop.hypr.enable = lib.mkEnableOption "enable hypr-ecosystem";
  };

  config = lib.mkIf config.desktop.hypr.enable {

    desktop.hypr.hyprland.enable = lib.mkDefault true;
    desktop.hypr.hyprlock.enable = lib.mkDefault true;
    desktop.hypr.hyprpaper.enable = lib.mkDefault true;

  };
}
