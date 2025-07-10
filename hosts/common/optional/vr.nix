{
  config,
  pkgs,
  lib,
  user,
  ...
}: {
  options = {
    vr.enable = lib.mkEnableOption "enable OpenVR";
  };

  config = lib.mkIf config.vr.enable {
    services = {
      monado = {
        enable = true;
        defaultRuntime = true;
        /*
         package = with pkgs;
        monado.overrideAttrs (
          finalAttrs: previousAttrs: {
            src = fetchFromGitLab {
              domain = "gitlab.freedesktop.org";
              owner = "thaytan";
              repo = "monado";
              rev = "dev-constellation-controller-tracking";
              hash = "sha256-IKO/bhUsISmRb3k+wAEscuTUXDyrzyVYQG1eJkLCIUI=";
            };

            patches = [];
          }
        );
        */
      };
      wivrn = {
        enable = true;
        openFirewall = true;

        # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
        # will automatically read this and work with WiVRn (Note: This does not currently
        # apply for games run in Valve's Proton)
        defaultRuntime = true;

        # Run WiVRn as a systemd service on startup
        autoStart = true;

        # Config for WiVRn (https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md)
        config = {
          enable = true;
          json = {
            # 1.0x foveation scaling
            scale = 1.0;
            # 100 Mb/s
            bitrate = 100000000;
            encoders = [
              {
                encoder = "vaapi";
                codec = "h265";
                # 1.0 x 1.0 scaling
                width = 1.0;
                height = 1.0;
                offset_x = 0.0;
                offset_y = 0.0;
              }
            ];
          };
        };
      };
    };
    /* # Add basalt-monado package
    environment.systemPackages = with pkgs; [
      basalt-monado
    ]; */
    systemd.user.services.monado.environment = {
      STEAMVR_LH_ENABLE = "1";
      XRT_COMPOSITOR_COMPUTE = "1";
      XRT_DEBUG_GUI = "0";
      WMR_HANDTRACKING = "0";
    };
    # OpenXR discovery
    /*
       home-manager.users."${user}" = {
      xdg.configFile."openxr/1/active_runtime.json".source = "${config.services.monado.package}/share/openxr/1/openxr_monado.json";

      xdg.configFile."openvr/openvrpaths.vrpath".text = builtins.toJSON {
        config = ["${config.home-manager.users."${user}".xdg.dataHome}/Steam/config"];
        external_drivers = null;
        jsonid = "vrpathreg";
        log = ["${config.home-manager.users."${user}".xdg.dataHome}/Steam/logs"];
        runtime = ["${pkgs.opencomposite}/lib/opencomposite"];
        version = 1;
      };

      # Hand tracking models (otherwise monado will crash)
      home.file.".local/share/monado/hand-tracking-models".source = pkgs.fetchgit {
        url = "https://gitlab.freedesktop.org/monado/utilities/hand-tracking-models";
        sha256 = "sha256-x/X4HyyHdQUxn3CdMbWj5cfLvV7UyQe1D01H93UCk+M=";
        fetchLFS = true;
      };
    };
    */
  };
}
