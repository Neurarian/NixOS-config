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
      # Add quantum settings to prevent crackling
      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 512;
          "default.clock.min-quantum" = 128;
          "default.clock.max-quantum" = 2048;
        };
      };

      # Configure PulseAudio backend for better compatibility
      extraConfig.pipewire-pulse."92-low-latency" = {
        context.modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              "pulse.min.req" = "512/48000";
              "pulse.default.req" = "512/48000";
              "pulse.max.req" = "512/48000";
              "pulse.min.quantum" = "128/48000";
              "pulse.max.quantum" = "2048/48000";
            };
          }
        ];
        "stream.properties" = {
          "node.latency" = "512/48000";
          "resample.quality" = 1;
        };
      };
    };
    udev.extraRules = ''
      # Arduino R4 Wifi udev rule
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", MODE:="0666"
    '';
  };
}
