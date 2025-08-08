{
  config,
  lib,
  user,
  ...
}: {
  options = {
    desktop.enable = lib.mkEnableOption "enable desktop & Hyprland related system settings";

    desktop.hyprlandLaunchCommand = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "hyprwrapperAmd";
      description = "The command to launch Hyprland with from greetd";
    };
  };

  config = lib.mkIf config.desktop.enable {
    services.gvfs.enable = true;

    # Wayland support for chromium and electron apps
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    security.polkit.enable = true;
    security.pam.services.hyprlock = {};
    # Autologin
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = config.desktop.hyprlandLaunchCommand;
          user = "${user}";
        };
      };
    };
  };
}
