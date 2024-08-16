{
  pkgs,
  lib,
  config,
  ...
}: {
  # light/dark specialisations
  # specialisation = let
  #   colorschemePath = "/org/gnome/desktop/interface/color-scheme";
  #   dconf = "${pkgs.dconf}/bin/dconf";

  #   dconfDark = lib.hm.dag.entryAfter ["dconfSettings"] ''
  #     ${dconf} write ${colorschemePath} "'prefer-dark'"
  #   '';
  #   dconfLight = lib.hm.dag.entryAfter ["dconfSettings"] ''
  #     ${dconf} write ${colorschemePath} "'prefer-light'"
  #   '';
  # in {
  #   light.configuration = {
  #     theme.name = "light";
  #     home.activation = {inherit dconfLight;};
  #   };
  #   dark.configuration = {
  #     theme.name = "dark";
  #     home.activation = {inherit dconfDark;};
  #   };
  # };

  theme = {
    wallpaper = let
      url = "https://drive.usercontent.google.com/download?id=1Kxn8p5jiSO7ihIAG70B_kfyL9HoTYHjB";
      sha256 = "1mfvhkaw07pm5mh05ggbxdc2hp97iybq7iz4yhj8h7xzhzb87ij8";
      ext = "png";
    in
      builtins.fetchurl {
        name = "wallpaper-${sha256}.${ext}";
        inherit url sha256;
      };
  };

  programs.matugen = {
    enable = true;
    package = pkgs.matugen;
    inherit (config.theme) wallpaper;
  };
}
