{
  config,
  lib,
  inputs,
  system,
  ...
}: {
  options = {
    desktop.applications.zen-browser.enable = lib.mkEnableOption "enable zen browser";
  };

  config = lib.mkIf config.desktop.applications.zen-browser.enable {
    home.packages = [
      inputs.zen-browser.packages.${system}.default
    ];
  };
}
