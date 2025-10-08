{
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  systemd.services.systemd-udev-settle.enable = false;

  boot = {
    kernelParams = [
      "nomodeset"
      "i915.modeset=0"
      "acpi_osi=Darwin"
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "systemd.mask=systemd-udev-settle.service"
      "rd.udev.log_level=3"
    ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };

  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;

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

  programs.hyprland.settings = {
    misc = {
      vrr = lib.mkForce 2;
      vfr = true;
    };
    decoration = {
      blur.enabled = lib.mkForce false;
      shadow.enabled = lib.mkForce false;
    };
  };

  networking.hostName = "macbook";

  security.tpm2.enable = true;

  environment.variables.LIBVA_DRIVER_NAME = "iHD";

  services = {
    scx.enable = true;
    # for SSD/NVME
    fstrim.enable = true;
  };
}
