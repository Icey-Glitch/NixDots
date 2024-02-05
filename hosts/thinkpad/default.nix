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
    # use latest kernel
    kernelPackages = pkgs.linuxPackages_xanmod_latest;

    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
    ];
  };

  environment.systemPackages = [config.boot.kernelPackages.cpupower];

  networking.hostName = "thinkpad";

  programs = {
    # enable hyprland and required options
    hyprland.enable = true;
  };

  security.tpm2.enable = true;

  services = {
    # for SSD/NVME
    fstrim.enable = true;
  };
}
