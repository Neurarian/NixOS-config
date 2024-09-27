{
  config,
  lib,
  ...
}:
{

  options = {
    graphics_erazer.enable = lib.mkEnableOption "enable notebook graphics module";
  };

  config = lib.mkIf config.graphics_erazer.enable {

    # Enable OpenGL
    hardware.graphics = {
      enable = true;
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {

      # Modesetting is required.
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    hardware.nvidia.prime = {
      # Hybrid Graphics configuration.
      sync.enable = true;
      intelBusId = "PCI:0:0:2";
      nvidiaBusId = "PCI:0:1:0";
    };

  };
}
