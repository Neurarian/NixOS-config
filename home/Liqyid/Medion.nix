{user, ...}: {
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "24.05";
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
    firefox.enable = true;
    zen-browser.enable = true;
    # Music 
    ytmusic.enable = true;
    # VFIO
    looking-glass.enable = true;
  };

  # Music daemon
  mpd.enable = true;

  scripts = {
    hyprlandWrapper = {
      gpuType = "nvidia";
    };
  };

  # Services
  systemd.user.enable = true;
  power_monitor.enable = true;
  polkit_gnome.enable = true;
}
