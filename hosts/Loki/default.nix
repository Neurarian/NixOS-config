{
  inputs,
  pkgs,
  user,
  ...
}:

{
  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  imports = [

    # Include the results of the hardware scan.
    ./disk-config.nix
    ./hardware-configuration.nix
    ../common/core
    ../common/optional
    inputs.disko.nixosModules.disko
    inputs.vermeer-undervolt.nixosModules.vermeer-undervolt
  ];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  boot.plymouth.extraConfig = "DeviceScale=1";

  networking.hostName = "Loki"; # Define your hostname.

  hardware.bluetooth.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable TRIM
  services.fstrim.enable = true;

  # System cooling GUI
  coolercontrol.enable = true;
  # FOSS Airdrop alternative
  localsend.enable = true;
  # Gaming
  programs.steam.enable = true;
  # Wayland support for chromium and electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  security.polkit.enable = true;
  security.pam.services.hyprlock = { };

  # VFIO: single GPU passthrough for 6800XT
  libvirt.enable = true;
  virtualisation.libvirtd.hooks.qemu = {
    "win-vfio" = pkgs.writers.writeBash "windows.sh" ''
      # Variables
      GUEST_NAME="$1"
      OPERATION="$2"
      SUB_OPERATION="$3"

      # Run commands when the vm is started/stopped.
      if [ "$GUEST_NAME" == "win10" ]; then
        if [ "$OPERATION" == "prepare" ]; then
          if [ "$SUB_OPERATION" == "begin" ]; then
            systemctl stop greetd

            sleep 4

            virsh nodedev-detach pci_0000_0b_00_0
            virsh nodedev-detach pci_0000_0b_00_1
            virsh nodedev-detach pci_0000_0b_00_2
            virsh nodedev-reattach pci_0000_0b_00_3

            modprobe -r amdgpu

            modprobe vfio-pci
          fi
        fi

        if [ "$OPERATION" == "release" ]; then
          if [ "$SUB_OPERATION" == "end" ]; then
            virsh nodedev-reattach pci_0000_0b_00_0
            virsh nodedev-reattach pci_0000_0b_00_1
            virsh nodedev-reattach pci_0000_0b_00_2
            virsh nodedev-reattach pci_0000_0b_00_3

            modprobe -r vfio-pci

            modprobe amdgpu

            systemctl start greetd
          fi
        fi
      fi
    '';

  };
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    # Autologin
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "Hyprland";
          user = "${user}";
        };
      };
    };
    vermeer-undervolt = {
      enable = true;
      cores = 8;
      milivolts = 30;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
      "networkmanager"
      "video"
      "libvirtd"
      "kvm"
    ];
  };

  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.nvidia.acceptLicense= true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    home-manager
    git
    neovim
    age
    wireplumber
    pwvucontrol
    ripgrep
    inputs.vermeer-undervolt.packages.${system}.default
  ];

  fonts.packages = with pkgs; [
    fira-code
    jetbrains-mono
    material-symbols
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "JetBrainsMono"
        "NerdFontsSymbolsOnly"
      ];
    })
  ];

  system.stateVersion = "24.05";

}
