{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    desktop.discord.enable = lib.mkEnableOption "enable discord client";
  };

  config = lib.mkIf config.desktop.discord.enable {

    nixpkgs.config.allowUnfree = true;
    home.packages = with pkgs; [
      discord
    ];
  };
}
