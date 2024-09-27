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

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
  };

  hardware = {
    enableRedistributableFirmware = true;

    graphics = lib.mkForce {
      enable = true;

      extraPackages = with pkgs; [
        libva
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        libvdpau-va-gl
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer
        vulkan-tools
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
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
