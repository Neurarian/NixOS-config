{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    desktop.applications.discord.enable = lib.mkEnableOption "enable discord client";
  };

  config = lib.mkIf config.desktop.applications.discord.enable {
    nixpkgs.config.allowUnfree = true;
    home.packages = with pkgs; [
      discord
    ];
  };
}
