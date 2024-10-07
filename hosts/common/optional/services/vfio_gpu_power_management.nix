{
  config,
  lib,
  ...
}:
{
  options = {
    gpu_power_management.enable = lib.mkEnableOption "disable gpu_power_management";
  };

  config = lib.mkIf config.gpu_power_management.enable {

    systemd.services."gpu-power-management" = {
      description = "Disable runtime gpu power management";
      wantedBy = [ "graphical.target" ];
      after = [ "graphical.target"];
      serviceConfig = {
        User = "root";
      };
      script = ''
        echo on > /sys/bus/pci/devices/0000:01:00.0/power/control && 
        echo on > /sys/bus/pci/devices/0000:01:00.1/power/control 
      '';
    };

    # needed to avoid host lock-up
    boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset"];
  };
}
