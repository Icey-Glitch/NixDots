{
  config,
  pkgs,
  self,
  lib,
  inputs,
  default,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_zen;
    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];
    blacklistedKernelModules = ["nouveau"];
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    cpu.intel.updateMicrocode = true;

    enableRedistributableFirmware = true;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  networking.hostName = "desktopm";

  security.tpm2.enable = true;

  services = {
    pcscd.enable = true;

    fwupd.enable = true;
    # for SSD/NVME
    fstrim.enable = true;
  };
}
