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

    profiles = {
      betterfox =
        extramaker "betterfox"
        // {
          extensions = with firefoxExtensions; [
            nur.repos.rycee.firefox-addons.ublock-origin
          ];
          # someOption = "value";
        };
    };
  };
}
