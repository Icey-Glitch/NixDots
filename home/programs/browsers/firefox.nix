{pkgs, ...}: let
  firefoxExtensions = pkgs;
in {
  programs.firefox = {
    enable = true;
    #betterfox = {
    #  enable = true;
    #  version = "master";
    #};

    profiles = {
      betterfox =
        {
          isDefault = true;
          extensions = with firefoxExtensions; [
            nur.repos.rycee.firefox-addons.ublock-origin
          ];
          # someOption = "value";
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
