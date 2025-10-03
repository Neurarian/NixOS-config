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
        ExecStart = pkgs.writeShellScript "start-libvirt-network" ''
          if ${pkgs.libvirt}/bin/virsh net-list --name | grep -q "^default$"; then
            echo "Default network is already active"
            exit 0
          fi
          ${pkgs.libvirt}/bin/virsh net-start default
          exit 0
        '';
      };
    };
    environment.systemPackages = [pkgs.libvirt];
  };
}
