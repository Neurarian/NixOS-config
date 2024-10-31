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

  networking.hostName = "Medion"; # Define your hostname.

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
    system.nixos.tags = [ "with-vfio" ];
    nvidia-intel-vfio.enable = true;
    gpu_power_management.enable = true;
  };
  # VMs
  libvirt.enable = true;
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
