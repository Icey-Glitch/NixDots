{
  pkgs,
  lib,
  ...
}: let
  colors = {
    dark = {
      foreground = "cdd6f4"; # Text
      background = "1e1e2e"; # Base
      regular0 = "45475a"; # Surface 1
      regular1 = "f38ba8"; # red
      regular2 = "a6e3a1"; # green
      regular3 = "f9e2af"; # yellow
      regular4 = "89b4fa"; # blue
      regular5 = "f5c2e7"; # maroon
      regular6 = "94e2d5"; # teal
      regular7 = "bac2de"; # Subtext 1
      bright0 = "585b70"; # Surface 2
      bright1 = "f38ba8"; # red
      bright2 = "a6e3a1"; # green
      bright3 = "f9e2af"; # yellow
      bright4 = "89b4fa"; # blue
      bright5 = "f5c2e7"; # maroon
      bright6 = "94e2d5"; # teal
      bright7 = "a6adc8"; # Subtext 0
    };

    light = {
      foreground = "4c4f69"; # Text
      background = "eff1f5"; # Base
      regular0 = "bcc0cc"; # Surface 1
      regular1 = "d20f39"; # red
      regular2 = "40a02b"; # green
      regular3 = "df8e1d"; # yellow
      regular4 = "1e66f5"; # blue
      regular5 = "e64553"; # maroon
      regular6 = "179299"; # teal
      regular7 = "5c5f77"; # Subtext 1
      bright0 = "acb0be"; # Surface 2
      bright1 = "d20f39"; # red
      bright2 = "40a02b"; # green
      bright3 = "df8e1d"; # yellow
      bright4 = "1e66f5"; # blue
      bright5 = "e64553"; # maroon
      bright6 = "179299"; # teal
      bright7 = "6c6f85"; # Subtext 0
    };
  };
in {
  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=10";
        horizontal-letter-offset = 0;
        vertical-letter-offset = 0;
        pad = "4x4 center";
        selection-target = "clipboard";
      };

      bell = {
        urgent = "yes";
        notify = "yes";
      };

      desktop-notifications = {
        command = "${lib.getExe pkgs.libnotify} -a \${app-id} -i \${app-id} \${title} \${body}";
      };

      scrollback = {
        lines = 10000;
        multiplier = 3;
        indicator-position = "relative";
        indicator-format = "line";
      };

      url = {
        launch = "${pkgs.xdg-utils}/bin/xdg-open \${url}";
        protocols = "http, https, ftp, ftps, file, mailto, ipfs";
      };

      cursor = {
        style = "beam";
        beam-thickness = 1;
      };

      colors =
        {
          alpha = 0.9;
        }
        // colors.dark;
    };
  };
}
