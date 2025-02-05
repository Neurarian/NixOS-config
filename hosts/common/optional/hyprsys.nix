{
  config,
  lib,
  user,
  ...
}: {
  options = {
    hyprsys = {
      enable = lib.mkEnableOption "enable hyprland specific system configurations";
      launchCommand = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "hyprwrapperAmd";
        description = "The command to launch Hyprland with from greetd";
      };
    };
  };

  config = lib.mkIf config.hyprsys.enable {
    # Wayland support for chromium and electron apps
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    security.polkit.enable = true;
    security.pam.services.hyprlock = {};
    # Autologin
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = config.hyprsys.launchCommand;
          user = "${user}";
        };
      };
    };
  };
}
