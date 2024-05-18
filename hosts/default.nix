{
  self,
  inputs,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;
    howdy = inputs.nixpkgs-howdy;
    mod = "${self}/system";

    # get the basic config to build on top of
    inherit (import "${self}/system") desktop laptop;

    # get these into the module system
    specialArgs = {inherit inputs self;};
  in {
    io = nixosSystem {
      inherit specialArgs;
      modules =
        laptop
        ++ [
          ./io
          "${mod}/core/lanzaboote.nix"

          "${mod}/programs/gamemode.nix"
          "${mod}/programs/hyprland.nix"
          "${mod}/programs/steam.nix"

          "${mod}/network/spotify.nix"
          "${mod}/network/syncthing.nix"

          "${mod}/services/kanata"
          "${mod}/services/gnome-services.nix"
          "${mod}/services/location.nix"

          {
            home-manager = {
              users.icey.imports = homeImports."icey@io";
              extraSpecialArgs = specialArgs;
            };
          }

          # enable unmerged Howdy
          {disabledModules = ["security/pam.nix"];}
          "${howdy}/nixos/modules/security/pam.nix"
          "${howdy}/nixos/modules/services/security/howdy"
          "${howdy}/nixos/modules/services/misc/linux-enable-ir-emitter.nix"

          inputs.agenix.nixosModules.default
          inputs.chaotic.nixosModules.default
        ];
    };

    thinkpad = nixosSystem {
      inherit specialArgs;
      modules =
        laptop
        ++ [
          ./thinkpad
          "${mod}/programs/gamemode.nix"
          "${mod}/programs/steam.nix"
          "${mod}/network/spotify.nix"
          "${mod}/programs/hyprland.nix"
          "${mod}/core/lanzaboote.nix"
          "${mod}/services/location.nix"
          "${mod}/services/gnome-services.nix"

          {
            home-manager = {
              users.icey.imports = homeImports."icey@thinkpad";
              extraSpecialArgs = specialArgs;
            };
          }
          inputs.chaotic.nixosModules.default
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
        ];
    };
    desktopm = nixosSystem {
      inherit specialArgs;
      modules =
        desktop
        ++ [
          ./desktopm
          "${mod}/programs/gamemode.nix"
          "${mod}/network/spotify.nix"
          "${mod}/programs/hyprland.nix"

          "${mod}/programs/steam.nix"
          "${mod}/services/location.nix"
          "${mod}/services/gnome-services.nix"
          "${mod}/hardware/nvidia-fixes.nix"
          "${mod}/hardware/k2200.nix"

          {
            home-manager = {
              users.icey.imports = homeImports."icey@desktopm";
              extraSpecialArgs = specialArgs;
            };
          }
          inputs.chaotic.nixosModules.default
          inputs.nixos-hardware.nixosModules.common-pc
          inputs.nixos-hardware.nixosModules.common-pc-ssd
          inputs.nixos-hardware.nixosModules.common-cpu-intel
          #inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        ];
    };

    # rog = nixosSystem {
    #   inherit specialArgs;
    #   modules =
    #     laptop
    #     ++ [
    #       ./rog
    #       "${mod}/core/lanzaboote.nix"

    #       "${mod}/programs/gamemode.nix"
    #       "${mod}/programs/hyprland.nix"
    #       "${mod}/programs/steam.nix"

    #       "${mod}/services/kanata"
    #       {home-manager.users.mihai.imports = homeImports."mihai@rog";}
    #     ];
    # };

    # kiiro = nixosSystem {
    #   inherit specialArgs;
    #   modules =
    #     desktop
    #     ++ [
    #       ./kiiro
    #       {home-manager.users.icey.imports = homeImports.server;}
    #     ];
    # };
  };
}
