{
  lib,
  pkgs,
  ...
}: let
  jsonFormat = pkgs.formats.json {};
in {
  options.cfirefox = {
    settings = lib.mkOption {
      # this type def is taken from HM because why reinvent the wheel
      type = lib.types.attrsOf (jsonFormat.type
        // {
          description = "Firefox preference (int, bool, string, and also attrs, list, float as a JSON string)";
        });
      default = {};
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra preferences to add to {file}`user.js`.
      '';
    };
  };
}
