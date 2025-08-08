{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
    ../common/core
    ../common/optional
    inputs.disko.nixosModules.disko
  ];
  environment.systemPackages = [pkgs.brightnessctl];

  networking = {
    hostName = "Medion"; # Define your hostname.
    networkmanager.ensureProfiles.profiles.ChArian_Inet.connection.interface-name = "wlp110s0";
    # FOSS Airdrop alternative
    localsend.enable = true;
    # Local SSH
    services.ssh.enable = true;
  };

  services = {
    # Enable TRIM
    fstrim.enable = true;
    printing.enable = true;
    libinput.enable = true;
  };
  hardware = {
    services = {
      powermanagement.enable = true;
      # Enable fn keybindings
      actkbd.enable = true;
    };
    graphics = {
      enable = true;
    };
    bluetooth.enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      # Hybrid Graphics configuration.
      sync.enable = true;
      intelBusId = "PCI:0:0:2";
      nvidiaBusId = "PCI:0:1:0";
    };
  };

  gaming.steam.enable = true;
  security.pam.services.hyprlock = {};

  /*
     # Option to attach GPU to VFIO on boot
  specialisation."VFIO".configuration = {
    libvirt.vfioNvidiaIntel.vfioOnBoot.enable = true;
    system.nixos.tags = ["with-vfio"];
    gpuPowerManagement.disable = true;
  };
  */

  # VMs
  virtualisation.libvirt = {
    enable = true;
    qemuHook = {
      enable = true;
      vmName = "win11";
      pciDevices = [
        "pci_0000_01_00_0"
        "pci_0000_01_00_1"
      ];
      gpuModule = "nvidia";
      vfioModule = "vfio-pci";
    };
    vfioNvidiaIntel = {
      enable = true;
      nvidiaDeviceIds = [
        # GTX 1070M
        "10de:1be1" # Graphics
        "10de:10f0" # Audio
      ];
    };
  };
  desktop = {
    enable = true;
    hyprlandLaunchCommand = "hyprwrapperNvidia";
  };

  nixpkgs.config = {
    nvidia.acceptLicense = true;
    allowUnfree = true;
  };
  system.stateVersion = "24.05";
}
