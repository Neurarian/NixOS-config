{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    hardware.bmboot.enable = lib.mkEnableOption "enable basic bare metal boot options";
  };

  config = lib.mkIf config.hardware.bmboot.enable {
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;

      kernelPatches = [
        {
          name = "amdgpu-fix-kfd-unload-d3hot";
          patch = pkgs.fetchpatch {
            url = "https://lore.kernel.org/amd-gfx/20260205164254.4091912-1-mario.limonciello@amd.com/raw";
            hash = "sha256-BIRAROGLAeK5csD4rvLfiUbcc+GyG00ysjQHJ4p5IVQ=";
          };
        }
      ];

      supportedFilesystems = {
        btrfs = true;
        ntfs = true;
      };
      plymouth = {
        enable = true;
        font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
        themePackages = [pkgs.catppuccin-plymouth];
        # mocha won't work for whatever reason
        theme = "catppuccin-macchiato";
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
