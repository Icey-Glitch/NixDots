{
  pkgs,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_xanmod;
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
  };

  networking.hostName = "desktopm";

  security.tpm2.enable = true;

  services = {
    pcscd.enable = true;

    # for SSD/NVME
    fstrim.enable = true;
  };
}
