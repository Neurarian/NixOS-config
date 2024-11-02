let
  # GTX 1070M
  gpuIDs = [
    "10de:1be1" # Graphics
    "10de:10f0" # Audio
  ];
in
{
  lib,
  user,
  config,
  ...
}:
{
  options.nvidia-intel-vfio.enable = with lib; mkEnableOption "Configure the machine for VFIO";

  config =     let
      cfg = config.nvidia-intel-vfio;
    in
    {
      boot = {
        extraModulePackages = with config.boot.kernelPackages; [ kvmfr ];
        kernelModules = [ "kvmfr" ];
        initrd.kernelModules = [
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"

          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ];

        kernelParams =
          [
            # enable IOMMU
            "intel_iommu=on"
            "iommu=pt"
          ]
          ++ lib.optional cfg.enable
            # isolate the GPU
            ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);
      };

      systemd.tmpfiles.rules = [
        "f /dev/shm/looking-glass 0660 ${user} qemu-libvirtd -"
      ];
      hardware.graphics.enable = true;
      virtualisation.spiceUSBRedirection.enable = true;

    };
}
