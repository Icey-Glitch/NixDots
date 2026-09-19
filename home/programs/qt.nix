{
  pkgs,
  config,
  lib,
  ...
}:
let
  KvLibadwaita = pkgs.fetchFromGitHub {
    owner = "GabePoel";
    repo = "KvLibadwaita";
    rev = "1f4e0bec44b13dabfa1fe4047aa8eeaccf2f3557";
    hash = "sha256-32RlnRBNJajD0Ps+vZSwVfDj6HzPpZjfm/LBG7u0eDg=";
    sparseCheckout = [ "src" ];
  };

  qtctConf = {
    Appearance = {
      custom_palette = false;
      icon_theme = config.gtk.iconTheme.name;
      standard_dialogs = "xdgdesktopportal";
      style = "kvantum";
    };
  };

  defaultFont = "${config.gtk.font.name},${builtins.toString config.gtk.font.size}";
in
{
  qt = {
    enable = true;
    # see home/services/system/theme.nix for kvantum config
    style.name = "kvantum";
    platformTheme.name = "qtct";

    # qtct config
    qt5ctSettings = qtctConf // {
      Fonts = {
        fixed = ''"${defaultFont},-1,5,50,0,0,0,0,0"'';
        general = ''"${defaultFont},-1,5,50,0,0,0,0,0"'';
      };
    };

    qt6ctSettings = qtctConf // {
      Fonts = {
        fixed = ''"${defaultFont},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
        general = ''"${defaultFont},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
      };
    };
  };

  xdg.configFile =
    let
      KvLibadwaita = pkgs.fetchFromGitHub {
        owner = "GabePoel";
        repo = "KvLibadwaita";
        rev = "1f4e0bec44b13dabfa1fe4047aa8eeaccf2f3557";
        hash = "sha256-32RlnRBNJajD0Ps+vZSwVfDj6HzPpZjfm/LBG7u0eDg=";
        sparseCheckout = [ "src" ];
      };
    in
    {
      # Kvantum config
      "Kvantum" = {
        source = "${KvLibadwaita}/src";
        recursive = true;
      };
    };
}
