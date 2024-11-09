{
  config,
  pkgs,
  self,
  lib,
  ...
}: {
  imports = [self.nixosModules.cfirefox];
  environment.sessionVariables = {
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

  cfirefox.extraConfig = ''
    user_pref("media.ffmpeg.vaapi.enabled", true);
    user_pref("media.ffvpx.enabled", false);
    user_pref("media.rdd-ffmpeg.enabled", false);
    user_pref("media.av1.enabled", false);
    user_pref("gfx.webrender.all", true);
    user_pref("layers.gpu-process.enabled", true);
    user_pref("widget.wayland.opaque-region.enabled", false);
    user_pref("gfx.x11-egl.force-enabled", true);
    user_pref("widget.dmabuf.force-enabled", true);
  '';

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
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "565.57.01";
      sha256_64bit = "sha256-buvpTlheOF6IBPWnQVLfQUiHv4GcwhvZW3Ks0PsYLHo=";
      sha256_aarch64 = lib.fakeHash;
      openSha256 = "sha256-/tM3n9huz1MTE6KKtTCBglBMBGGL/GOHi5ZSUag4zXA=";
      settingsSha256 = "sha256-H7uEe34LdmUFcMcS6bz7sbpYhg9zPCb/5AmZZFTx1QA=";
      persistencedSha256 = lib.fakeHash;
    };

    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    #package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
