{
  # For better pipewire performance
  security.rtkit.enable = true;
  # Services
  services = {
    # Enable sound.
    printing.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    udev.extraRules = ''
      # Arduino R4 Wifi udev rule
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", MODE:="0666"
    '';
  };
}
