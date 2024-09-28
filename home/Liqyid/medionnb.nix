{ user, ... }:
{

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
  discord.enable = true;
  overskride.enable = true;
  ytmusic.enable = true;
  clivis.enable = true;
  mpd.enable = true;
  ags.enable = true;
}
