{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations =
    let
      # shorten paths
      inherit (inputs.nixpkgs.lib) nixosSystem;

      howdy = inputs.nixpkgs-howdy;

      homeImports = import "${self}/home/profiles";

      mod = "${self}/system";
      # get the basic config to build on top of
      inherit (import mod) desktop laptop;

      # get these into the module system
      specialArgs = { inherit inputs self; };
    in
    {
      io = nixosSystem {
        inherit specialArgs;
        modules = laptop ++ [
          ./io
          "${mod}/core/lanzaboote.nix"

          "${mod}/programs/gamemode.nix"
          "${mod}/programs/hyprland"
          "${mod}/programs/games.nix"

          "${mod}/network/spotify.nix"
          "${mod}/network/syncthing.nix"

          "${mod}/services/kanata"
          "${mod}/services/gnome-services.nix"
          "${mod}/services/location.nix"

          {
            home-manager = {
              users.icey.imports = homeImports."icey@io";
              extraSpecialArgs = specialArgs;
              backupFileExtension = ".hm-backup";
            };
          }

          # enable unmerged Howdy
          { disabledModules = [ "security/pam.nix" ]; }
          "${howdy}/nixos/modules/security/pam.nix"
          "${howdy}/nixos/modules/services/security/howdy"
          "${howdy}/nixos/modules/services/misc/linux-enable-ir-emitter.nix"

          inputs.agenix.nixosModules.default
          inputs.chaotic.nixosModules.default
        ];
      };

      thinkpad = nixosSystem {
        inherit specialArgs;
        modules = laptop ++ [
          ./thinkpad
          "${mod}/programs/gamemode.nix"
          "${mod}/network/spotify.nix"
          "${mod}/programs/hyprland"
          "${mod}/core/lanzaboote.nix"
          "${mod}/services/location.nix"
          "${mod}/services/gnome-services.nix"
          "${mod}/programs/games.nix"

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

      macbook = nixosSystem {
        inherit specialArgs;
        modules = laptop ++ [
          ./macbook
          "${mod}/programs/gamemode.nix"
          "${mod}/network/spotify.nix"
          "${mod}/programs/hyprland"
          "${mod}/services/location.nix"
          "${mod}/services/gnome-services.nix"
          "${mod}/programs/games.nix"

          {
            home-manager = {
              users.icey.imports = homeImports."icey@thinkpad";
              extraSpecialArgs = specialArgs;
            };
          }
          inputs.chaotic.nixosModules.default
          inputs.nixos-hardware.nixosModules.apple-macbook-pro-11-5
        ];
      };
      desktopm = nixosSystem {
        inherit specialArgs;
        modules = desktop ++ [
          ./desktopm
          "${mod}/programs/gamemode.nix"
          "${mod}/network/spotify.nix"
          "${mod}/programs/hyprland"
          "${mod}/programs/games.nix"

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
      #       "${mod}/programs/games.nix"

      #       "${mod}/services/kanata"
      #       {home-manager.users.icey.imports = homeImports."icey@rog";}
      #     ];
      # };

      nixos = nixosSystem {
        inherit specialArgs;
        modules = [
          ./wsl
          "${mod}/core/users.nix"
          "${mod}/nix"
          "${mod}/programs/zsh.nix"
          "${mod}/programs/home-manager.nix"
          {
            home-manager = {
              users.mihai.imports = homeImports.server;
              extraSpecialArgs = specialArgs;
              backupFileExtension = ".hm-backup";
            };
          }
        ];
      };
    };
}
