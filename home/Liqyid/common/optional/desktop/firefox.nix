{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  options = {
    desktop.firefox.enable = lib.mkEnableOption "enable firefox browser";
  };

  config = lib.mkIf config.desktop.firefox.enable {
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      GDK_BACKEND = "wayland";
    };

    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
          extensions.packages = with inputs.firefox-addons.packages."${system}"; [
            ublock-origin
            privacy-badger
            i-dont-care-about-cookies
            bitwarden
            sponsorblock
            darkreader
            unpaywall
            vimium
            firefox-color
          ];
          bookmarks = {
            force = true;
            settings = [
              {
                name = "Toolbar";
                toolbar = true;
                bookmarks = [
                  {
                    name = "Catppuccin-Mocha-Lavender";
                    url = "https://color.firefox.com/?theme=XQAAAAJHBAAAAAAAAABBqYhm849SCicxcUcPX38oKRicm6da8pFtMcajvXaAE3RJ0F_F447xQs-L1kFlGgDKq4IIvWciiy4upusW7OvXIRinrLrwLvjXB37kvhN5ElayHo02fx3o8RrDShIhRpNiQMOdww5V2sCMLAfehhpWbjL_1RPuSDS6JMrP5SMm3V5s8DPdjrylB8odQkBKx3hwS8DfSgUd_K1gnYDiqF6FLqjZ1i5o2Ag7ndcuIMtTOff0Mv_AUAr9gmCgTwJLuHS5akRaMkSVVO8YgQjswELYw-q6z3M9DY23nuubC_GQIUqlw0_94uTV6vwegBVDkZbRRpVsBlfXUf_GqVF9q79Pr6uBA49roImTVMPyDZ9TZWf4oGlebH55k7lGonhR7tIVq6T0EitalyQmofr7ZRrkD9AZTe2f1aJuLnVsX_37dxUN2Qzo48s6AGZ7O1x-eVU1x4fGwGN3uMKhlk7umStxFC_xhSJTiVloH7_g2XYIb96FY63jjMAnWH3NlYewHQpDH4WEe-AcSxUy9IkyEnirYFd0aPe_x62ahv3L4HEH_8pylyA";
                  }
                  {
                    name = "Catppuccin-Firefox";
                    tags = [
                      "theme"
                      "firefox"
                    ];
                    url = "https://github.com/catppuccin/firefox";
                  }
                  {
                    name = "MyNixOS";
                    tags = [
                      "search"
                      "nixpkgs"
                    ];
                    url = "https://mynixos.com/nixpkgs/package";
                  }
                  {
                    name = "Home Manager Options";
                    tags = [
                      "search"
                      "home-manager-options"
                    ];
                    url = "https://home-manager-options.extranix.com/";
                  }
                  {
                    name = "Github";
                    tags = ["repository"];
                    url = "https://github.com/dashboard";
                  }
                ];
              }
            ];
          };
          search = {
            force = true;
            default = "Searx";
            order = [
              "Searx"
              "google"
            ];
            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@np"];
              };
              "NixOS Wiki" = {
                urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
                icon = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = ["@nw"];
              };
              "Searx" = {
                urls = [{template = "https://searx.tiekoetter.com/search?q={searchTerms}";}];
                icon = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = ["@searx"];
              };
              "bing".metaData.hidden = true;
              "google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
            };
          };
          settings = {
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.startup.homepage" = "https://searx.tiekoetter.com/";
            "browser.search.defaultenginename" = "Searx";
            "browser.search.order.1" = "Searx";
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.newtabpage.activity-stream.default.sites" = false;
            "browser.newtabpage.blocked" = ''{"4gPpjkxgZzXPVtuEoAL9Ig==":1,"26UbzFJ7qT9/4DhodHKA1Q==":1,"eV8/WsSLxHadrTL1gAxhug==":1,"gLv0ja2RYVgxKdp0I5qwvA==":1,"T9nJot5PurhJSy8n038xGA==":1,"afooYCodMAvS/moZ8M8x6g==":1}'';
            "geo.provider.use_geoclue" = false;
            "extensions.getAddons.showPane" = false;
            "extensions.htmlaboutaddons.recommendations.enabled" = false;
            "browser.discovery.enabled" = false;
            "browser.shopping.experience2023.enabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.server" = "data:,";
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.coverage.opt-out" = true;
            "toolkit.coverage.opt-out" = true;
            "toolkit.coverage.endpoint.base" = "";
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;
            "app.shield.optoutstudies.enabled" = false;
            "app.normandy.enabled" = false;
            "app.normandy.api_url" = "";
            "breakpad.reportURL" = "";
            "browser.tabs.crashReporting.sendReport" = false;
            "browser.crashReports.unsubmittedCheck.enabled" = false;
            "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
            "captivedetect.canonicalURL" = "";
            "network.captive-portal-service.enabled" = false;
            "network.connectivity-service.enabled" = false;
            "network.prefetch-next" = false;
            "network.dns.disablePrefetch" = true;
            "network.dns.disablePrefetchFromHTTPS" = true;
            "network.predictor.enabled" = false;
            "network.predictor.enable-prefetch" = false;
            "network.http.speculative-parallel-limit" = 0;
            "browser.places.speculativeConnect.enabled" = false;
            "browser.send_pings" = false;
            "network.proxy.socks_remote_dns" = true;
            "network.file.disable_unc_paths" = true;
            "network.gio.supported-protocols" = "";
            "browser.urlbar.suggest.quicksuggest.sponsored" = false;
            "browser.urlbar.trending.featureGate" = false;
            "browser.formfill.enable" = false;
            "browser.search.separatePrivateDefault" = true;
            "browser.search.separatePrivateDefault.ui.enabled" = true;
            "signon.autofillForms" = false;
            "signon.formlessCapture.enabled" = false;
            "network.auth.subresource-http-auth-allow" = 1;
            "browser.cache.disk.enable" = false;
            "browser.privatebrowsing.forceMediaMemoryCache" = true;
            "media.memory_cache_max_size" = 65536;
            "browser.sessionstore.privacy_level" = 2;
            "toolkit.winRegisterApplicationRestart" = false;
            "browser.shell.shortcutFavicons" = false;
            "security.ssl.require_safe_negotiation" = true;
            "security.tls.enable_0rtt_data" = false;
            "security.OCSP.enabled" = 1;
            "security.OCSP.require" = true;
            "security.cert_pinning.enforcement_level" = 2;
            "security.remote_settings.crlite_filters.enabled" = true;
            "security.pki.crlite_mode" = 2;
            "dom.security.https_only_mode" = true;
            "dom.security.https_only_mode_send_http_background_request" = false;
            "security.ssl.treat_unsafe_negotiation_as_broken" = true;
            "browser.xul.error_pages.expert_bad_cert" = true;
            "network.http.referer.XOriginTrimmingPolicy" = 2;
            "privacy.userContext.enabled" = true;
            "privacy.userContext.ui.enabled" = true;
            "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
            "media.peerconnection.ice.default_address_only" = true;
            "dom.disable_window_move_resize" = true;
            "browser.download.start_downloads_in_tmp_dir" = true;
            "browser.helperApps.deleteTempFileOnExit" = true;
            "browser.uitour.enabled" = false;
            "devtools.debugger.remote-enabled" = false;
            "permissions.manager.defaultsUrl" = "";
            "webchannel.allowObject.urlWhitelist" = "";
            "network.IDN_show_punycode" = true;
            "pdfjs.disabled" = false;
            "pdfjs.enableScripting" = false;
            "browser.tabs.searchclipboardfor.middleclick" = false;
            "browser.contentanalysis.enabled" = false;
            "browser.contentanalysis.default_result" = 0;
            "browser.download.useDownloadDir" = false;
            "browser.download.alwaysOpenPanel" = false;
            "browser.download.manager.addToRecentDocs" = false;
            "browser.download.always_ask_before_handling_new_types" = true;
            "extensions.postDownloadThirdPartyPrompt" = false;
            "browser.contentblocking.category" = "strict";
            "privacy.sanitize.sanitizeOnShutdown" = true;
            "privacy.clearOnShutdown.cache" = true;
            "privacy.clearOnShutdown_v2.cache" = true;
            "privacy.clearOnShutdown.downloads" = true;
            "privacy.clearOnShutdown.formdata" = true;
            "privacy.clearOnShutdown.history" = true;
            "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
            "privacy.clearOnShutdown.cookies" = true;
            "privacy.clearOnShutdown.offlineApps" = true;
            "privacy.clearOnShutdown.sessions" = true;
            "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
            "privacy.clearSiteData.cache" = true;
            "privacy.clearSiteData.cookiesAndStorage" = false;
            "privacy.clearSiteData.historyFormDataAndDownloads" = true;
            "privacy.cpd.cache" = true;
            "privacy.clearHistory.cache" = true;
            "privacy.cpd.formdata" = true;
            "privacy.cpd.history" = true;
            "privacy.clearHistory.historyFormDataAndDownloads" = true;
            "privacy.cpd.cookies" = false;
            "privacy.cpd.sessions" = true;
            "privacy.cpd.offlineApps" = false;
            "privacy.clearHistory.cookiesAndStorage" = false;
            "privacy.sanitize.timeSpan" = 0;
            "privacy.window.maxInnerWidth" = 1600;
            "privacy.window.maxInnerHeight" = 900;
            "privacy.resistFingerprinting.block_mozAddonManager" = true;
            "privacy.spoof_english" = 1;
            "browser.link.open_newwindow" = 3;
            "browser.link.open_newwindow.restriction" = 0;
            "extensions.blocklist.enabled" = true;
            "network.http.referer.spoofSource" = false;
            "security.dialog_enable_delay" = 1000;
            "privacy.firstparty.isolate" = false;
            "extensions.webcompat.enable_shims" = true;
            "security.tls.version.enable-deprecated" = false;
            "extensions.webcompat-reporter.enabled" = false;
            "extensions.quarantinedDomains.enabled" = true;
            "browser.startup.homepage_override.mstone" = "ignore";
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
            "browser.urlbar.showSearchTerms.enabled" = false;
            "extensions.autoDisableScopes" = 0;
            "extensions.enabledScopes" = 15;
          };
        };
      };
    };
  };
}
