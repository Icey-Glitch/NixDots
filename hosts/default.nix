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

      homeImports = import "${self}/home/profiles";

      mod = "${self}/system";
      # get the basic config to build on top of
      inherit (import mod) desktop laptop;

      # get these into the module system
      specialArgs = { inherit inputs self; };
    in
    rec {
      io = nixosSystem {
        inherit specialArgs;
        modules = laptop ++ [
          ./io
          "${mod}/core/lanzaboote.nix"

          "${mod}/programs/gamemode.nix"
          "${mod}/programs/hyprland"
          "${mod}/programs/games.nix"

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

          inputs.agenix.nixosModules.default
        ];
      };

      thinkpad = nixosSystem {
        inherit specialArgs;
        modules = laptop ++ [
          ./thinkpad
          "${mod}/programs/gamemode.nix"
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
          "${mod}/programs/hyprland"
          "${mod}/programs/games.nix"

          "${mod}/services/location.nix"
          "${mod}/services/gnome-services.nix"
          "${mod}/hardware/nvidia-fixes.nix"
          "${mod}/hardware/k2200.nix"
          "${mod}/hardware/virt.nix"

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

      # Xen dom0 + DRAKVUF (hypervisor-level VMI tracing) variant of
      # desktopm -- see ~/Git/xen-drakvuf-nix for why. This has to be a
      # genuinely separate top-level nixosConfiguration, not a
      # specialisation of `desktopm`: the Xen dom0 module's boot-entry
      # generator (xenBootBuilder) is driven entirely by the *base*
      # config's own `boot.loader.systemd-boot.extraInstallCommands`, which
      # a specialisation has no way to inject into -- tried that first, and
      # confirmed by its absence: no xen-*.conf/xen-*.efi were ever written
      # under /boot/loader when it lived in a specialisation.
      #
      # Built via `.extendModules` on `desktopm` (needs the `rec` above)
      # rather than duplicating its module list. Switch to it with:
      #   sudo nixos-rebuild boot --flake .#desktopm-xen
      # `desktopm`'s own boot entry, default, and gaming-VM setup are
      # completely unaffected -- this is an additional, separate entry.
      desktopm-xen = desktopm.extendModules {
        modules = [
          "${self}/modules/virtualisation/xen-dom0.nix"
          ({ lib, ... }: {
            # Xen has to own VT-x/EPT/IOMMU as the base hypervisor --
            # incompatible with the existing KVM/VFIO GPU-passthrough
            # gaming-VM setup (system/hardware/virt.nix, plain `= true`
            # assignment, hence mkForce to win). Only disabled here;
            # `desktopm`'s own config and default are untouched.
            virt.vfio.enable = lib.mkForce false;

            # xen-dom0.nix's defaults are sized for a small dedicated box
            # (xenhost); desktopm has far more headroom (16 cores/46GiB).
            virtualisation.xen.dom0Resources = {
              maxVCPUs = lib.mkForce 4;
              memory = lib.mkForce 8192;
              maxMemory = lib.mkForce 8192;
            };
          })
        ];
      };

      # Dedicated Xen dom0 + DRAKVUF research box -- see
      # hosts/xenhost/default.nix and ~/Git/xen-drakvuf-nix. Deployed via
      # nixos-anywhere (disko handles partitioning), not a manual install.
      xenhost = nixosSystem {
        inherit specialArgs;
        modules = [
          ./xenhost
          inputs.disko.nixosModules.disko
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
              users.icey.imports = homeImports.server;
              extraSpecialArgs = specialArgs;
              backupFileExtension = ".hm-backup";
            };
          }
        ];
      };
    };
}
