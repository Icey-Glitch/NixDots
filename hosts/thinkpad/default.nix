{
  lib,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;

    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
    ];
  };

  hardware = {
    enableRedistributableFirmware = true;
  };

  networking.hostName = "thinkpad";

  security.tpm2.enable = true;

  environment.systemPackages = [pkgs.scx];
  chaotic.scx.enable = true;

  environment.variables.LIBVA_DRIVER_NAME = "iHD";

  services = {
    # for SSD/NVME
    fstrim.enable = true;
  };
}
