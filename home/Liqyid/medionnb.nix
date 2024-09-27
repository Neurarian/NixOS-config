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
  discord.enable = true;
  overskride.enable = true;
  ytmusic.enable = true;
}
