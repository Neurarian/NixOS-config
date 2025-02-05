{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    bmboot.enable = lib.mkEnableOption "enable basic bare metal boot options";
  };

  config = lib.mkIf config.bmboot.enable {
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
      plymouth = {
        enable = true;
        font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
        themePackages = [pkgs.catppuccin-plymouth];
        theme = "catppuccin-mocha";
      };

      # Enable "Silent Boot"
      consoleLogLevel = 0;
      initrd = {
        verbose = false;
        systemd.enable = true;
        luks.devices.crypted.allowDiscards = true;
      };
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "plymouth.use-simpledrm"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];
      # Hide the OS choice for bootloaders.
      # It's still possible to open the bootloader list by pressing any key
      # It will just not appear on screen unless a key is pressed
      # Use the systemd-boot EFI boot loader.
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        timeout = 0;
        grub.configurationLimit = 3;
      };
      # Use tmpfs to decrease strain on NVME
      tmp.useTmpfs = true;
    };
  };
}
