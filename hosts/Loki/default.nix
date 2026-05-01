{
  inputs,
  config,
  ...
}: {
  imports = [
    ./diskConfig.nix
    ./hardware-configuration.nix
    ../common/core
    ../common/optional
    inputs.disko.nixosModules.disko
    inputs.vermeer-undervolt.nixosModules.vermeer-undervolt
  ];

  boot = {
    # Scale plymouth to 2k
    plymouth.extraConfig = "DeviceScale=1";
    # Thrustmaster Force Feedback support
    extraModulePackages = [config.boot.kernelPackages.hid-tmff2];
    kernelModules = ["hid_tmff_new"];
    blacklistedKernelModules = [
      "hid_thrustmaster"
      "xpad"
    ];
  };
  services.udev.packages = [config.boot.kernelPackages.hid-tmff2];

  networking = {
    hostName = "Loki"; # Define your hostname.
    networkmanager.ensureProfiles.profiles.ChArian_Inet.connection.interface-name = "wlp5s0";
    # FOSS Airdrop alternative
    localsend.enable = true;
    # Local SSH
    services.ssh.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
    # System cooling GUI
    services.coolercontrol.enable = true;
  };

  services = {
    # Enable TRIM
    fstrim.enable = true;
    # Undervolt 5800x3d
    vermeer-undervolt = {
      enable = true;
      cores = 8;
      milivolts = 30;
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Hyprland specific system configurations
  desktop = {
    enable = true;
    hyprlandLaunchCommand = "hyprwrapperAmd";
  };
  # Gaming
  gaming = {
    steam = {
      enable = true;
      ckan.enable = true;
    };
    vr.enable = true;
  };
  # VFIO: single GPU passthrough for 6800XT
  virtualisation.libvirt = {
    enable = true;
    qemuHook = {
      enable = true;
      vmName = "win10";
      pciDevices = [
        "pci_0000_0b_00_0"
        "pci_0000_0b_00_1"
        "pci_0000_0b_00_2"
        "pci_0000_0b_00_3"
      ];
      gpuModule = "amdgpu";
      vfioModule = "vfio-pci";
    };
  };

  system.stateVersion = "26.05";
}
