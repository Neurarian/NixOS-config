{
  config,
  lib,
  user,
  ...
}: {
  options.homessh.enable = lib.mkEnableOption "Enable SSH common access config";
  config = lib.mkIf config.homessh.enable {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    users.users.${user}.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVdi3tcOZ091Adi3z9UTmWHIfKMwTiBph/7nZO50QEl loki"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICA4VcmR3haHAJStifcDnX/3qfqpKVfOpTv4dM9x2lfD medion"
    ];
  };
}
