{
  pkgs,
  lib,
  config,
  inputs,
  self,
  ...
}: let
  Firefox-custom = pkgs.wrapFirefox pkgs.firefox-unwrapped_nightly {};
in {
  imports = [
    self.nixosModules.cfirefox
    inputs.arkenfox.hmModules.default
  ];

  home.sessionVariables.DEFAULT_BROWSER = "${Firefox-custom}/bin/firefox";

  programs.firefox = {
    enable = true;
    arkenfox = {
      enable = true;
      version = "128.0";
    };
    package = Firefox-custom;
    #betterfox = {
    #  enable = true;
    #  version = "master";
    #};
    policies = let
      Lists = [
        "https://big.oisd.nl/"
        "http://sbc.io/hosts/hosts"
        "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
        "https://gist.githubusercontent.com/Icey-Glitch/d7e365b793bfae21759b750e316d3744/raw/63a1661f3c7e0aac85a8fbb9499fa305d4507e91/ytbetter.txt"
      ];
    in {
      "3rdparty".Extensions = {
        # https://github.com/gorhill/uBlock/blob/master/platform/common/managed_storage.json
        "uBlock0@raymondhill.net".adminSettings = {
          userSettings = {
            uiTheme = "dark";
            uiAccentCustom = true;
            cloudStorageEnabled = lib.mkForce false; # Security liability?
            importedLists = Lists;
            externalLists = lib.concatStringsSep "\n" Lists;
          };
          selectedFilterLists =
            Lists
            ++ [
              "CZE-0"
              "adguard-generic"
              "adguard-annoyance"
              "adguard-social"
              "adguard-spyware-url"
              "easylist"
              "easyprivacy"
              "plowe-0"
              "ublock-abuse"
              "ublock-badware"
              "ublock-filters"
              "ublock-privacy"
              "ublock-quick-fixes"
              "ublock-unbreak"
              "urlhaus-1"
            ];
        };
      };
    };

    profiles = {
      betterfox =
        {
          isDefault = true;
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            sponsorblock
            clearurls
            old-reddit-redirect
            youtube-redux
            return-youtube-dislikes
            reddit-enhancement-suite
            darkreader
            fastforwardteam
            violentmonkey
          ];

          arkenfox = {
            enable = true;
            "0000".enable = true;
            "0100" = {
              enable = true;
              "0102"."browser.startup.page".value = 1;
              "0104"."browser.newtabpage.enabled".value = true;
            };
            "0300" = {
              enable = true;
            };
            "2400" = {
              enable = true;
            };
            "2600" = {
              "2603".enable = true;
            };
            "2800" = {
              "2815".enable = false;
            };
            "4000" = {
              enable = true;
              "4002".enable = true;
              "4002"."privacy.fingerprintingProtection.overrides".value = "+AllTargets,-CSSPrefersColorScheme";
            };
            "4500" = {
              enable = false;
              "4501".enable = true;
              "4504".enable = false; # letter box
              "4510"."browser.display.use_system_colors".value = true; # sys color
              "4520".enable = false; # webgl
            };
          };
          settings =
            config.cfirefox.settings
            // {
            };
        }
        // (
          let
            splitLines = str: builtins.split "\n" str;
            betterfox = pkgs.fetchFromGitHub {
              owner = "yokoffing";
              repo = "Betterfox";
              rev = "HEAD";
              hash = "sha256-Uu/a5t74GGvMIJP5tptqbiFiA+x2hw98irPdl8ynGoE=";
            };
          in {
            extraConfig = builtins.concatStringsSep "\n" [
              config.cfirefox.extraConfig
              ''
                ${builtins.readFile "${betterfox}/Fastfox.js"}
                ${builtins.readFile "${betterfox}/Peskyfox.js"}
                ${builtins.readFile "${betterfox}/Securefox.js"}

                /* Custom User.js */
                user_pref("browser.tabs.firefox-view-next", false);
                user_pref("privacy.sanitize.sanitizeOnShutdown", false);
                user_pref("privacy.clearOnShutdown.cache", false);
                user_pref("privacy.clearOnShutdown.cookies", false);
                user_pref("privacy.clearOnShutdown.offlineApps", false);
                user_pref("browser.sessionstore.privacy_level", 0);
                user_pref("browser.newtabpage.activity-stream.system.showWeather", false);


                // Disable Firefox Accounts & Sync
                user_pref("identity.fxaccounts.enabled", false);
                user_pref("identity.fxaccounts.remote.signup.uri", "");
                user_pref("identity.fxaccounts.remote.signin.uri", "");
                user_pref("identity.fxaccounts.remote.force_auth.uri", "");
                user_pref("identity.mobilepromo.android", "");
                user_pref("identity.mobilepromo.ios", "");

                // Disable Firefox Sync
                user_pref("services.sync.engine.bookmarks", false);
                user_pref("services.sync.engine.history", false);
                user_pref("services.sync.engine.passwords", false);
                user_pref("services.sync.engine.prefs", false);
                user_pref("services.sync.engine.tabs", false);
                user_pref("services.sync.enabled", false);

                // Disable sync setup from about:preferences
                user_pref("services.sync.autoconnect", false);

                // Disable Firefox Sync migration
                user_pref("services.sync.prefs.sync.fxaccounts.enabled", false);
                user_pref("services.sync.prefs.sync.fxaccounts.auth.uri", "");
                user_pref("services.sync.prefs.sync.identity.fxaccounts.enabled", false);

                // Disable other sync-related services
                user_pref("services.sync.registerEngines", "");
                user_pref("services.sync.username", "");
                user_pref("services.sync.scheduler.idleInterval", 0);
                user_pref("services.sync.scheduler.activeInterval", 0);
                user_pref("services.sync.scheduler.immediateInterval", 0);
                user_pref("services.sync.scheduler.singleDeviceInterval", 0);


              ''
            ];
          }
        );
      # test = {
      #   id = 1;
      #  betterfox = {
      #   enable = true;
      #};
      #name = "test";
      #betterfox = {
      #"FASTFOX".enable = true;
      #"smoothfox".enable = true;
      #};
      #};
    };
  };
}
