# Xen dom0 support (nixpkgs' revived xen-dom0.nix module, NixOS 24.11+).
#
# Generic/reusable -- deliberately NOT part of the default `virt` module
# bundle (modules/virtualisation/default.nix) since Xen has to own
# VT-x/EPT/IOMMU as the base hypervisor, which is incompatible with the
# VFIO/KVM GPU-passthrough gaming-VM setup configured in this same
# directory (vfio.nix). Import this directly into whichever host needs
# Xen dom0 (currently: xenhost, and desktopm-xen in hosts/default.nix).
{ ... }:
{
  virtualisation.xen = {
    enable = true;

    # Modest default dom0 allocation, safe for smaller machines. Hosts with
    # more headroom (e.g. desktopm-xen, 16 cores/46GiB) bump this via their
    # own extra module -- see hosts/default.nix.
    dom0Resources = {
      maxVCPUs = 2;
      memory = 4096; # MiB
      maxMemory = 4096;
    };
  };

  # Xen's hard requirements (assertions in nixpkgs' xen-dom0.nix module) --
  # set unconditionally here so this module is self-contained regardless of
  # which host imports it, rather than assuming some other host-specific
  # file already sets them (true for desktopm via system/core/boot.nix, but
  # not guaranteed for a fresh host like xenhost).
  boot.initrd.systemd.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Dom0-capable kernel config (CONFIG_XEN=y, CONFIG_XEN_DOM0=y, etc.) --
  # nixpkgs' default `linuxPackages` already has this enabled ("All NixOS
  # kernels come with this enabled by default" per the module's own
  # comment), so no kernelPackages override is needed here. Verify with
  # `zcat /proc/config.gz | grep CONFIG_XEN_DOM0` if a host ever picks a
  # kernel variant where that turns out not to hold.
}
