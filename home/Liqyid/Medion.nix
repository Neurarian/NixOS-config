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

  desktop = {
    # Enable entire hypr-ecosystem
    hypr.enable = true;
    # GUI
    ags.enable = true;
    gtk-module.enable = true;
    nautilus.enable = true;
    fuzzel.enable = true;
    overskride.enable = true;
    firefox.enable = true;
    wlogout.enable = true;
    discord.enable = true;
    # Music 
    ytmusic.enable = true;
    mpd.enable = true;
    cava.enable = true;
    # VFIO
    looking-glass.enable = true;
  };

  # Services
  systemd.user.enable = true;
  power_monitor.enable = true;
  polkit_gnome.enable = true;

}
