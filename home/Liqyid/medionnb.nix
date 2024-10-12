{ user, pkgs, ... }:
{

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "24.05";
    pointerCursor = {
      package = pkgs.catppuccin-cursors.macchiatoDark;
      name = "Catppuccin-Macchiato-Dark-Cursors";
    };
  };

  imports = [
    ./common
  ];
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # systemd.user.enable = true;

  discord.enable = true;
  overskride.enable = true;
  ytmusic.enable = true;
  mpd.enable = true;
  ags.enable = true;
  gtk_module.enable = true;
  power_monitor.enable = true;
  polkit_gnome.enable = true;
  fuzzel.enable = true;
  wlogout.enable = true;
  cava.enable = true;
  looking-glass.enable = true;

  desktop = {
    # Enable entire hypr-ecosystem
    hypr.enable = true;
  };

}
