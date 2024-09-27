{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    discord.enable = lib.mkEnableOption "enable discord client";
  };

  config = lib.mkIf config.discord.enable {

    nixpkgs.config.allowUnfree = true;
    home.packages = with pkgs; [
      discord
    ];
  };
}
