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

  networking.hostName = "Fujitsu";

  # Enable TRIM
  services.fstrim.enable = true;

  hardware.bluetooth.enable = true;
  system.stateVersion = "24.05";

}
