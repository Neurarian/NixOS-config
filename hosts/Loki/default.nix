{inputs, ...}: {
  imports = [
    ./diskConfig.nix
    ./hardware-configuration.nix
    ../common/core
    ../common/optional
    inputs.disko.nixosModules.disko
    inputs.vermeer-undervolt.nixosModules.vermeer-undervolt
  ];

  # Scale plymouth to 2k
  boot.plymouth.extraConfig = "DeviceScale=1";

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
    hyprlandLaunchCommand = "Hyprland";
  };
  # Gaming
  gaming = {
    steam.enable = true;
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
      ];
      gpuModule = "amdgpu";
      vfioModule = "vfio-pci";
    };
  };

  system.stateVersion = "24.05";
}
