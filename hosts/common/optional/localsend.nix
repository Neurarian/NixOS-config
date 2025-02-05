{
  config,
  lib,
  ...
}: {
  options = {
    localsend.enable = lib.mkEnableOption "enable localsend file transfer";
  };

  config = lib.mkIf config.localsend.enable {
    programs.localsend = {
      enable = true;
      openFirewall = true;
    };
  };
}
