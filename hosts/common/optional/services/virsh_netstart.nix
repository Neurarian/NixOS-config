{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    virsh_netstart_service.enable = lib.mkEnableOption "enable virsh_netstart_service";
  };

  config = lib.mkIf config.virsh_netstart_service.enable {
    systemd.services.virsh-netstart = {
      description = "Setup networking for VFIO";
      wantedBy = ["multi-user.target"];
      after = ["libvirtd.service"];
      serviceConfig = {
        User = "root";
        ExecStart = ''
          ${pkgs.libvirt}/bin/virsh net-start default
        '';
      };
    };
    environment.systemPackages = with pkgs; [libvirt];
  };
}
