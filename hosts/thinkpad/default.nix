{
  config,
  pkgs,
  self,
  inputs,
  default,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot = {
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

  services = {
    # for SSD/NVME
    fstrim.enable = true;
  };
}
