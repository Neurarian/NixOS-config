{
  config,
  lib,
  user,
  ...
}: {
  options.networking.services.wifi.enable =
    lib.mkEnableOption "Enable home WiFi profile and libvirt firewall rules";

  config = lib.mkIf config.networking.services.wifi.enable {
    sops.secrets = let
      home = "wifi/home/";
    in {
      "${home}ssid" = {};
      "${home}uuid" = {};
      "${home}psk" = {};
    };

    networking = {
      networkmanager = {
        enable = true;
        ensureProfiles.profiles = {
          ChArian_Inet = {
            connection = {
              id = config.sops.secrets."wifi/home/ssid".path;
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
            proxy = {};
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
      firewall = {
        enable = true;
        trustedInterfaces = ["virbr0"];
      };
    };
  };
}
