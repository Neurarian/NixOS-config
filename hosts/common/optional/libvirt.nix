{
  lib,
  config,
  pkgs,
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
          description = "The name of the VM to apply the hook to.";
        };
        pciDevices = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "List of PCI devices to detach/reattach for GPU passthrough";
        };
        gpuModule = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "The GPU module to be unloaded and reloaded.";
        };
        vfioModule = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "The VFIO module to be loaded for passthrough.";
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

      # Service to declaratively start VFIO networking
      virsh_netstart_service.enable = true;
      virtualisation.libvirtd = {
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
    };
}
