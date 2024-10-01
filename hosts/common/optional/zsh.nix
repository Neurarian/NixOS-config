{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    zsh.enable = lib.mkEnableOption "Set zsh as default shell on system";
  };

  config = lib.mkIf config.zsh.enable {
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
  };

}
