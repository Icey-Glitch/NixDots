{
  pkgs,
  lib,
  ...
}: let
  firefoxExtensions = pkgs;
  Firefox-custom = pkgs.wrapFirefox (pkgs.firefox-unwrapped_nightly) {};
in {
  programs.firefox = {
    enable = true;
    package = Firefox-custom;
    #betterfox = {
    #  enable = true;
    #  version = "master";
    #};
    policies = let
      Lists = [
        "https://big.oisd.nl/"
        "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
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
          extensions = with firefoxExtensions; [
            nur.repos.rycee.firefox-addons.ublock-origin
            nur.repos.rycee.firefox-addons.sponsorblock
            nur.repos.rycee.firefox-addons.clearurls
          ];
          # someOption = "value";
          settings = {
            "media.ffmpeg.vaapi.enabled" = true;
            "media.ffvpx.enabled" = false;
            "media.av1.enabled" = false;
            "gfx.webrender.all" = true;
            "media.hardware-video-decoding.force-enabled" = true;
          };
        }
        // (
          let
            betterfox = pkgs.fetchFromGitHub {
              owner = "yokoffing";
              repo = "Betterfox";
              rev = "122.1";
              hash = "sha256-eHocB5vC6Zjz7vsvGOTGazuaUybqigODEIJV9K/h134=";
            };
          in {
            extraConfig = ''
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

            '';
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
