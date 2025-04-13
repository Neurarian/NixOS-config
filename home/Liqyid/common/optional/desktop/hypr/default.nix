{
  config,
  lib,
  ...
}: {
  imports = [
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
  ];

  options = {
    desktop.hypr.enable = lib.mkEnableOption "enable hypr-ecosystem";
  };

  config = lib.mkIf config.desktop.hypr.enable {
    desktop.hypr = {
      hyprland.enable = lib.mkDefault true;
      hyprlock.enable = lib.mkDefault true;
      hyprpaper.enable = lib.mkDefault true;
    };

    # See ../../scripts/
    scripts = {
      # Enable GPU-specific wrapper scripts
      hyprlandWrapper.enable = lib.mkForce true;
      # Enable wallpaper colorgeneration of several main desktop applications
      # Currently handled via matshell
      # wallpaperSetter.enable = lib.mkForce true;
    };
  };
}
