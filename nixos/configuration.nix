# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, user, ... }:

{
  # Enable weekly garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly;";
    options = "--delete-older-than 10d";
  };

  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./global-env-vars.nix
    ./sops.nix
    ./nvidia.nix
  ];
  
  # Test notebook graphics module

  graphics_erazer.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    plymouth = {
      enable = true;
      font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
      themePackages = [ pkgs.catppuccin-plymouth ];
      theme = "catppuccin-macchiato";
    };

    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd = {
      verbose = false;
      systemd.enable = true;
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
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  };

  services.greetd =
    let
      tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
      session = "${pkgs.hyprland}/bin/Hyprland";
    in
    {
      enable = true;
      settings = {
        initial_session = {
          command = "${session}";
          user = "${user}";
        };
        default_session = {
          command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time -cmd ${session}";
          user = "greeter";
        };
      };
    };
  
  networking.hostName = "NixOS"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Sops encrypted wifi creds
  sops.secrets."wifi/home/ssid" = { };
  sops.secrets."wifi/home/uuid" = { };
  sops.secrets."wifi/home/psk" = { };

  networking.networkmanager = {
    enable = true; # Easiest to use and most distros use this by default.
    ensureProfiles.profiles = {
      ChArian_Inet = {
        connection = {
          id = config.sops.secrets."wifi/home/ssid".path;
          interface-name = "wlp110s0";
          permissions = "user:${user}:;";
          timestamp = "1725477527";
          type = "wifi";
          uuid = config.sops.secrets."wifi/home/uuid".path;
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
        proxy = { };
        wifi = {
          mode = "infrastructure";
          ssid = config.sops.secrets."wifi/home/ssid".path;
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = config.sops.secrets."wifi/home/psk".path;
        };
      };
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

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

  programs.steam.enable = true;
  security.pam.services.hyprlock = { };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Doesn't help with firefox not using wl
  /*
    xdg = {
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
      };
    };
  */

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user}= {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
      "networkmanager"
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
    age
    lshw
    home-manager
    ags
    wl-clipboard
    fastfetch
    stow
    pywal
    wireplumber
    wget
    polkit_gnome
    # nvim requirements
    gcc
    unzip
    gnumake
    ripgrep
  ];
  fonts.packages = with pkgs; [
    fira-code
    jetbrains-mono
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "JetBrainsMono"
        "NerdFontsSymbolsOnly"
      ];
    })
  ];
  security.polkit.enable = true;
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

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
