{
  config,
  lib,
  ...
}:
{

  options = {
    localsend.enable = lib.mkEnableOption "enable localsend file transfer";
  };

  config = lib.mkIf config.graphics_erazer.enable {

    programs.localsend = {
      enable = true;
      openFirewall = true;
    };

  };
}
