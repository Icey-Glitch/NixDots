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
  programs.firefox = {
    enable = true;
    arkenfox = {
      enable = true;
      version = "126.1";
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
            reddit-enhancement-suite
            darkreader
            fastforwardteam
            violentmonkey
          ];
          # someOption = "value";
          settings =
            config.cfirefox.settings
            // {
            };
        }
        // (
          let
            betterfox = pkgs.fetchFromGitHub {
              owner = "yokoffing";
              repo = "Betterfox";
              rev = "126.0";
              hash = "sha256-W0JUT3y55ro3yU23gynQSIu2/vDMVHX1TfexHj1Hv7Q=";
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
