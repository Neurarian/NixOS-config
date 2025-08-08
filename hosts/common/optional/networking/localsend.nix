{
  config,
  lib,
  ...
}: {
  options = {
    networking.localsend.enable = lib.mkEnableOption "enable localsend file transfer";
  };

  config = lib.mkIf config.networking.localsend.enable {
    programs.localsend = {
      enable = true;
      openFirewall = true;
    };
  };
}
