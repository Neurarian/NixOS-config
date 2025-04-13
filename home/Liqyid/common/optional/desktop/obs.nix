{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    desktop.obs.enable = lib.mkEnableOption "enable OBS Studio video recording and streaming";
  };

  config = lib.mkIf config.desktop.obs.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    };
  };
}
