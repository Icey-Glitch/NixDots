# Dedicated Xen dom0 + DRAKVUF (hypervisor-level VMI tracing) research box.
# See ~/Git/xen-drakvuf-nix for the project this supports. Headless -- no
# desktop/Hyprland profile, unlike desktopm/io/etc.
{ self, ... }:
{
  imports = [
    ./disko.nix
    "${self}/modules/virtualisation/xen-dom0.nix"
  ];

  networking.hostName = "xenhost";

  # No hardware-configuration.nix exists yet -- nixos-anywhere generates the
  # real one from the target during deploy. Set explicitly so this evaluates
  # cleanly before then; harmless once the generated file also sets it.
  nixpkgs.hostPlatform = "x86_64-linux";

  hardware.cpu.intel.updateMicrocode = true;

  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keyFiles = [ ../../secrets/yubikey.pub ];
  users.users.icey = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [ ../../secrets/yubikey.pub ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "26.05";
}
