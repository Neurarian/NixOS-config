{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    virtualisation.libvirtd.services.netstart.enable = lib.mkEnableOption "enable virsh netstart service";
  };

  config = lib.mkIf config.virtualisation.libvirtd.services.netstart.enable {
    systemd.services.virsh-netstart = {
      description = "Setup networking for VFIO";
      wantedBy = ["multi-user.target"];
      after = ["libvirtd.service"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "root";
        ExecStart = ''
          ${pkgs.libvirt}/bin/virsh net-start default
        '';
      };
    };
    environment.systemPackages = [pkgs.libvirt];
  };
}
