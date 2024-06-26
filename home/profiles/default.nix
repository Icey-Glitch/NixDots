{
  self,
  inputs,
  ...
}: let
  # get these into the module system
  extraSpecialArgs = {inherit inputs self;};

  homeImports = {
    "icey@io" = [
      ../.
      ./io
    ];
    "icey@thinkpad" = [
      ../.
      ./thinkpad
    ];
    "icey@desktopm" = [
      ../.
      ./desktopm
    ];
    "icey@rog" = [
      ../.
      ./rog
    ];
    server = [
      ../.
      ./server
    ];
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in {
  # we need to pass this to NixOS' HM module
  _module.args = {inherit homeImports;};

  flake = {
    homeConfigurations = {
      "icey_io" = homeManagerConfiguration {
        modules = homeImports."icey@io";
        inherit pkgs extraSpecialArgs;
      };

      "icey_thinkpad" = homeManagerConfiguration {
        modules = homeImports."icey@thinkpad";
        inherit pkgs extraSpecialArgs;
      };
      "icey_desktopm" = homeManagerConfiguration {
        modules = homeImports."icey@desktopm";
        inherit pkgs extraSpecialArgs;
      };

      "icey_rog" = homeManagerConfiguration {
        modules = homeImports."icey@rog";
        inherit pkgs extraSpecialArgs;
      };

      server = homeManagerConfiguration {
        modules = homeImports.server;
        inherit pkgs extraSpecialArgs;
      };
    };
  };
}
