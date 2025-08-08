{
  config,
  lib,
  ...
}: {
  options = {
    hardware.services.gpuPowerManagement.disable = lib.mkEnableOption "disable gpu power management";
  };

  config = lib.mkIf config.hardware.services.gpuPowerManagement.disable {
    systemd.services."gpu-power-management" = {
      description = "Disable runtime gpu power management";
      wantedBy = ["graphical.target"];
      after = ["graphical.target"];
      serviceConfig = {
        User = "root";
      };
      script = ''
        echo on > /sys/bus/pci/devices/0000:01:00.0/power/control &&
        echo on > /sys/bus/pci/devices/0000:01:00.1/power/control
      '';
    };

    # needed to avoid host lock-up
    boot.blacklistedKernelModules = ["nouveau" "nvidia" "nvidia_drm" "nvidia_modeset"];
  };
}
