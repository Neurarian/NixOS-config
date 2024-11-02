{
  inputs,
  ...
}:

{
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
    ../common/core
    ../common/optional
    inputs.disko.nixosModules.disko

  ];

  networking = {
    hostName = "Medion"; # Define your hostname.
    networkmanager.ensureProfiles.profiles.ChArian_Inet.connection.interface-name = "wlp110s0";
  };
  # Enable TRIM
  services.fstrim.enable = true;

  # Notebook specific modules
  graphics_erazer.enable = true;
  powermanagement.enable = true;

  hardware.bluetooth.enable = true;
  # FOSS Airdrop alternative
  localsend.enable = true;
  programs.steam.enable = true;
  security.pam.services.hyprlock = { };
  # Wayland support for chromium and electron apps

  # Option to attach GPU to VFIO on boot
  specialisation."VFIO".configuration = {
    libvirt.vfioNvidiaIntel.vfioOnBoot.enable = true;
    system.nixos.tags = [ "with-vfio" ];
    gpu_power_management.enable = true;
  };
  # VMs
  libvirt = {
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
  services.printing.enable = true;
  # Enable fn keybindings
  actkbd.enable = true;
  hyprsys = {
    enable = true;
    launchCommand = "hyprwrapper";
  };

  services.libinput.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  system.stateVersion = "24.05";

}
