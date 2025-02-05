{
  config,
  lib,
  ...
}: {
  options = {
    desktop.looking-glass.enable = lib.mkEnableOption "enable looking-glass";
  };

  config = lib.mkIf config.desktop.looking-glass.enable {
    programs = {
      looking-glass-client = {
        enable = true;
        settings = {
          app = {
            allowDMA = true;
            shmFile = "/dev/kvmfr0";
          };

          win = {
            fullScreen = true;
            showFPS = false;
            jitRender = true;
          };

          spice = {
            enable = true;
            audio = true;
          };

          input = {
            rawMouse = true;
            escapeKey = 62;
          };
        };
      };
    };
  };
}
