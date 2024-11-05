{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.virt.vfio;
  qemu-patches = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/fengjixuchui/qemu-anti-detection/refs/heads/main/qemu-8.2.0.patch";
    sha256 = "sha256-zCF/eb8quODgcNC3Rpcf2zQcriWoTzYTnprCSbh98yo=";
  };
in {
  imports = [
    inputs.nixos-vfio.nixosModules.default
  ];
  options.virt.vfio = {
    enable = mkEnableOption "Enable VFIO";
    vfioDevices = mkOption {
      type = types.listOf types.str;
      default = ["10de:1e81" "10de:10f8" "10de:1ad8" "10de:1ad9" "1002:164e"];
    };
    blacklistNvidia = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config =
    mkIf cfg.enable
    {
      virtualisation.vfio = {
        enable = true;
        IOMMUType = "intel";
        inherit (cfg) blacklistNvidia;
        ignoreMSRs = false;
        devices = cfg.vfioDevices;
      };

      users.users.qemu-libvirtd.group = "qemu-libvirtd";
      users.groups.qemu-libvirtd = {};

      boot.kernelModules = ["vfio_pci" "vfio_iommu_type1" "vfio"];

      boot.initrd.kernelModules = ["vfio_pci" "vfio_iommu_type1" "vfio"];

      # Add virt-amanger, Looking Glass client and Moonlight
      users.users.icey = {
        packages = with pkgs; [
          virt-manager
          looking-glass-client
          moonlight-qt
        ];
      };

      nixpkgs.overlays = [
        (final: prev: {
          qemu_pinned = inputs.nixpkgs-qemu.legacyPackages.${final.system}.qemu;
          qemu_kvm = final.qemu_pinned.overrideAttrs (_: {
            patches = [
              qemu-patches
            ];
          });
        })
      ];

      virtualisation.libvirtd = {
        enable = true;
        deviceACL = [
          "/dev/kvm"
          "/dev/kvmfr0"
          "/dev/kvmfr1"
          "/dev/kvmfr2"
          "/dev/shm/scream"
          "/dev/shm/looking-glass"
        ];
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
          ovmf = {
            enable = true;
            packages = [
              (pkgs.OVMFFull.override {
                secureBoot = true;
                tpmSupport = true;
              })
              .fd
            ];
          };
        };
      };

      # Add three kvmfr devices
      virtualisation.kvmfr = {
        enable = true;

        devices = [
          {
            size = 128; # in MiB
            permissions = {
              user = "icey";
              group = "icey";
              mode = "0777";
            };
          }
          {
            size = 128; # in MiB
            permissions = {
              user = "icey";
              group = "icey";
              mode = "0777";
            };
          }

          {
            size = 128; # in MiB
            permissions = {
              user = "icey";
              group = "icey";
              mode = "0777";
            };
          }
        ];
      };

      # Reserve total of 16GiB, 1GiB each, hugepages
      virtualisation.hugepages = {
        enable = true;
        defaultPageSize = "1G";
        pageSize = "1G";
        numPages = 16;
      };

      # Add shmem areas for both scream and looking-glass as a kvmfr backup
      virtualisation.sharedMemoryFiles = {
        scream = {
          user = "icey";
          group = "icey"; # TODO: check permissions
          mode = "666";
        };
        looking-glass = {
          user = "icey";
          group = "icey";
          mode = "666";
        };
      };
      users.users.icey.extraGroups = ["libvirtd" "kvm" "input"];
    };
}
