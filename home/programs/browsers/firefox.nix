{
  config,
  inputs,
  pkgs,
  self,
  lib,
  ...
}: let
  extramaker = _profileName: {
    extraConfig = lib.readFile (toString "${self}/home/programs/browsers/${_profileName}.js");
  };

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
        extramaker "betterfox"
        // {
          isDefault = true;
          extensions = with firefoxExtensions; [
            nur.repos.rycee.firefox-addons.ublock-origin
          ];
          # someOption = "value";
        };
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
