{
  lib,
  config,
  pkgs,
  user,
  ...
}:
{
  options = {
    libvirt = {
      enable = lib.mkEnableOption "Enable libvirt module";

      # Hook to detach & reattach GPU
      qemuHook = {
        enable = lib.mkEnableOption "Enable hook for GPU passthrough";
        vmName = lib.mkOption {
          type = lib.types.str;
          default = "";
          example = "win10";
          description = "The name of the VM to apply the hook to.";
        };
        pciDevices = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [
            "pci_0000_0b_00_0"
            "pci_0000_0b_00_1"
            "pci_0000_0b_00_2"
          ];
          description = "List of PCI devices to detach/reattach for GPU passthrough";
        };
        gpuModule = lib.mkOption {
          type = lib.types.str;
          default = "";
          example = "amdgpu";
          description = "The GPU module to be unloaded and reloaded.";
        };
        vfioModule = lib.mkOption {
          type = lib.types.str;
          default = "";
          example = "vfio-pci";
          description = "The VFIO module to be loaded for passthrough.";
        };
      };
      vfioNvidiaIntel = {
        enable = lib.mkEnableOption "Setup required options for Nvidia GPU passthrough";
        vfioOnBoot.enable = lib.mkEnableOption "Hook GPU to VFIO driver on boot";
        nvidiaDeviceIds = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [
            "10de:1be1"
            "10de:10f0"
          ];
          description = "List of device IDs to attach to vfio-pci driver";
        };
      };
    };
  };

  config =
    let
      hookCfg = config.libvirt.qemuHook;
    in
    lib.mkIf config.libvirt.enable {

      programs.virt-manager.enable = true;
      hardware.graphics.enable = true;

      # Service to declaratively start VFIO networking
      virsh_netstart_service.enable = true;
      virtualisation = {
        libvirtd = {
          enable = true;
          qemu = {
            package = pkgs.qemu_kvm;
            runAsRoot = true;
            swtpm.enable = true;
            ovmf = {
              enable = true;
              packages = [ pkgs.OVMFFull.fd ];
            };
          };
          hooks.qemu = lib.mkIf hookCfg.enable {
            "gpuPassthrough" = pkgs.writers.writeBash "gpuPassthrough" ''
              # Variables
              GUEST_NAME="$1"
              OPERATION="$2"
              SUB_OPERATION="$3"

              # Run commands when the VM is started/stopped.
              if [ "$GUEST_NAME" == "${hookCfg.vmName}" ]; then
                if [ "$OPERATION" == "prepare" ]; then
                  if [ "$SUB_OPERATION" == "begin" ]; then
                    systemctl stop greetd
                    sleep 4

                    # Detach PCI devices
                    ${lib.concatStringsSep "\n" (map (pci: "virsh nodedev-detach ${pci}") hookCfg.pciDevices)}

                    # Unload GPU module and load VFIO module
                    modprobe -r ${hookCfg.gpuModule}
                    modprobe ${hookCfg.vfioModule}
                  fi
                fi

                if [ "$OPERATION" == "release" ]; then
                  if [ "$SUB_OPERATION" == "end" ]; then
                    # Reattach PCI devices
                    ${lib.concatStringsSep "\n" (map (pci: "virsh nodedev-reattach ${pci}") hookCfg.pciDevices)}

                    # Unload VFIO module and reload GPU module
                    modprobe -r ${hookCfg.vfioModule}
                    modprobe ${hookCfg.gpuModule}

                    systemctl start greetd
                  fi
                fi
              fi
            '';
          };
        };
        spiceUSBRedirection.enable = true;
      };
      boot =
        let
          cfgNvidiaIntel = config.libvirt.vfioNvidiaIntel;
        in
        lib.mkIf cfgNvidiaIntel.enable {
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
            ++ lib.optional cfgNvidiaIntel.vfioOnBoot.enable
              # isolate the GPU
              ("vfio-pci.ids=" + lib.concatStringsSep "," cfgNvidiaIntel.nvidiaDeviceIds);
        };
      # looking glass
      # systemd.tmpfiles.rules = [
      #   "f /dev/shm/looking-glass 0660 ${user} qemu-libvirtd -"
      # ];
    };
}
