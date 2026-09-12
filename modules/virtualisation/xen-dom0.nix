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

    # Required by DRAKVUF itself, not optional tuning -- these are upstream
    # drakvuf-sandbox's own documented Xen cmdline
    # (docs/usage/getting_started.rst's GRUB_CMDLINE_XEN_DEFAULT), missing
    # here until root-caused live: `drakvuf -r kernel.json -d vm-1 ...`
    # failed outright with "Failed to initialize DRAKVUF: drakvuf_init()
    # failed" against a freshly-restored, otherwise-healthy VM (confirmed
    # via VNC screenshot + an independent VMI process-list query showing a
    # normal desktop and the correct explorer.exe PID). docs/faq.rst: "DRAKVUF
    # is tightly coupled with altp2m" -- and altp2m is gated by this
    # *hypervisor* boot flag, distinct from the per-domain `altp2m = 2` line
    # already in cfg.template, which alone is not sufficient.
    #
    # ept=ad=0/hap_1gb=0/hap_2mb=0 are also the most likely explanation for a
    # second, separately-observed symptom: `drakrun`'s own analysis flow
    # restoring a snapshot and getting no response from `drakshell` (the
    # in-guest agent) even after 90s, on a VM independently confirmed alive
    # and interactive the whole time. Without ept=ad=0, Xen's EPT
    # access/dirty-bit tracking (used to compute the dirty-page set during
    # `xl save`) can miss pages under exactly the kind of fine-grained,
    # actively-mutating state a hijacked-thread agent like drakshell keeps --
    # explaining "guest looks completely fine, this one thing's state didn't
    # survive save/restore".
    #
    # dom0_vcpus_pin=1 included since it's part of the same documented set
    # (pins dom0's vcpus to real cores, avoiding dom0/domU scheduling
    # interference); smt=0 is a no-op on this hardware (already SMT-off, per
    # `lscpu`) but kept for parity with upstream's exact recommendation and
    # in case this module ever runs on SMT-capable hardware.
    bootParams = [
      "dom0_vcpus_pin=1"
      "force-ept=1"
      "ept=ad=0"
      "hap_1gb=0"
      "hap_2mb=0"
      "altp2m=1"
      "hpet=legacy-replacement"
      "smt=0"
    ];
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
