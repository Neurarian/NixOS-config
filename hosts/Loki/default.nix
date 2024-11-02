{
  inputs,
  ...
}:

{
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
  };

  hardware.bluetooth.enable = true;

  # Enable TRIM
  services.fstrim.enable = true;

  nixpkgs.config.allowUnfree = true;
  # Hyprland specific system configurations
  hyprsys = {
    enable = true;
    launchCommand = "Hyprland";
  };
  # System cooling GUI
  coolercontrol.enable = true;
  # FOSS Airdrop alternative
  localsend.enable = true;
  # Gaming
  programs.steam.enable = true;
  # Enable CUPS to print documents.
  # Undervolt 5800x3d
  services.vermeer-undervolt = {
    enable = true;
    cores = 8;
    milivolts = 30;
  };

  # VFIO: single GPU passthrough for 6800XT
  libvirt = {
    enable = true;
    qemuHook = {
      enable = true;
      vmName = "win10";
      pciDevices = [
        "pci_0000_0b_00_0"
        "pci_0000_0b_00_1"
        "pci_0000_0b_00_2"
      ];
      gpuModule = "amdgpu";
      vfioModule = "vfio-pci";
    };
  };

  system.stateVersion = "24.05";

}
