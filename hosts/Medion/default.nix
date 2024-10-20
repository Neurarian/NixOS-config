# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
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

  ];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";


  networking.hostName = "Medion"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable TRIM
  services.fstrim.enable = true;
  boot.initrd.luks.devices.crypted = {
    allowDiscards = true;
  };

  # Notebook specific modules
  graphics_erazer.enable = true;
  powermanagement.enable = true;

  hardware.bluetooth.enable = true;
  # FOSS Airdrop alternative
  localsend.enable = true;
  programs.steam.enable = true;
  security.pam.services.hyprlock = { };
  # Wayland support for chromium and electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  security.polkit.enable = true;

  # Option to attach GPU to VFIO on boot
  # specialisation."VFIO".configuration = {
  #   system.nixos.tags = [ "with-vfio" ];
  #   vfio.enable = true;
  #   gpu_power_management.enable = true;
  # };
  # VMs
  libvirt.enable = true;
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable fn keybindings
  actkbd.enable = true;
  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };
    # Autologin Hyprland on nvidia GPU  TODO: make this common/optional with gpu specific option for command
    greetd = {
      enable = true;
      settings = {
        default_session = {
          # Script: /home/Liqyid/common/scripts/nvidia_hyprland_wrapper.nix
          # Wrapper to launch Hyprland correctly 
          command = "hyprwrapper";
          user = "${user}";
        };
      };
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
    ]; # Enable ‘sudo’ for the user.
    #   packages = with pkgs; [
    #     firefox
    #     tree
    #   ];
  };

  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.nvidia.acceptLicense= true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pciutils
    home-manager
    age
    lshw
    wireplumber
    pwvucontrol
    wget
    wl-clipboard
    polkit_gnome
    ripgrep
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}
