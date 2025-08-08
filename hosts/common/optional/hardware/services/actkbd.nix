{
  config,
  lib,
  user,
  ...
}: {
  options = {
    hardware.services.actkbd.enable = lib.mkEnableOption "Enable fn key volumen control";
  };

  config = lib.mkIf config.hardware.services.actkbd.enable {
    services.actkbd = {
      enable = true;
      bindings = [
        {
          keys = [113];
          events = ["key"];
          command = "XDG_RUNTIME_DIR=/run/user/$(id -u ${user}) /run/current-system/sw/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        }
        {
          keys = [114];
          events = ["key"];
          command = "XDG_RUNTIME_DIR=/run/user/$(id -u ${user}) /run/current-system/sw/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        }
        {
          keys = [115];
          events = ["key"];
          command = "XDG_RUNTIME_DIR=/run/user/$(id -u ${user}) /run/current-system/sw/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        }
      ];
    };
  };
}
