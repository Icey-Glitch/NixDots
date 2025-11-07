# Source: https://gist.github.com/CRTified/43b7ce84cd238673f7f24652c85980b3
{
  lib,
  config,
  ...
}:
with lib;
{
  options.virtualisation = {
    sharedMemoryFiles = mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              name = mkOption {
                visible = false;
                default = name;
                type = types.str;
              };
              user = mkOption {
                type = types.str;
                default = "root";
                description = "Owner of the memory file";
              };
              group = mkOption {
                type = types.str;
                default = "root";
                description = "Group of the memory file";
              };
              mode = mkOption {
                type = types.str;
                default = "0600";
                description = "Group of the memory file";
              };
            };
          }
        )
      );
      default = { };
    };
  };
}
