{ pkgs, lib, config, ... }: {
  options.desktop.applications.oversteer.enable =
    lib.mkEnableOption "enable oversteer FFB control";

  config = lib.mkIf config.desktop.applications.oversteer.enable {
    services.udev.packages = with pkgs; [ oversteer ];
  };
}
