{
  config,
  user,
  ...
}:
{

  # Sops encrypted wifi creds
  sops.secrets =
    let
      home = "wifi/home/";
    in
    {
      "${home}ssid" = { };
      "${home}uuid" = { };
      "${home}psk" = { };
    };

  networking.hostName = "NixOS"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager = {
    enable = true; # Easiest to use and most distros use this by default.
    ensureProfiles.profiles = {
      ChArian_Inet = {
        connection = {
          id = config.sops.secrets."wifi/home/ssid".path;
          interface-name = "wlp110s0";
          permissions = "user:${user}:;";
          timestamp = "1725477527";
          type = "wifi";
          uuid = config.sops.secrets."wifi/home/uuid".path;
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
        proxy = { };
        wifi = {
          mode = "infrastructure";
          ssid = config.sops.secrets."wifi/home/ssid".path;
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = config.sops.secrets."wifi/home/psk".path;
        };
      };
    };
  };
}
