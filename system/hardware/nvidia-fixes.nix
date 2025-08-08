{
  config,
  pkgs,
  self,
  lib,
  ...
}: {
  environment = {
    systemPackages = [pkgs.libva-utils];
    sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";

      ## hw decoding
      EGL_PLATFORM = "wayland";
      NVD_BACKEND = "direct";
      MOZ_DISABLE_RDD_SANDBOX = "1";

      # refresh rate
      __GL_GSYNC_ALLOWED = "1";
      #__GL_VRR_ALLOWED = "0";
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      nvidia-vaapi-driver
      #libvdpau-va-gl
    ];
  };

  #  boot.extraModprobeConfig = ''
  #    options nvidia NVreg_RegistryDwords="PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3"
  #  '';

  boot = {
    kernelParams = ["nvidia-drm.fbdev=1"];

    extraModprobeConfig =
      "options nvidia "
      + lib.concatStringsSep " " [
        # nvidia assume that by default your CPU does not support PAT,
        # but this is effectively never the case in 2023
        "NVreg_UsePageAttributeTable=1"
        # This may be a noop, but it's somewhat uncertain
        "NVreg_EnablePCIeGen3=1"
        # This is sometimes needed for ddc/ci support, see
        # https://www.ddcutil.com/nvidia/
        #
        # Current monitor does not support it, but this is useful for
        # the future
        "NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100"
        # When (if!) I get another nvidia GPU, check for resizeable bar
        # settings
      ];
  };

  # this is all from TLATER

  hardware.nvidia = {
    powerManagement.enable = true;
    open = true;
    #package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
