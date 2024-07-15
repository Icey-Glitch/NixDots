{
  config,
  pkgs,
  self,
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

  hardware.opengl = {
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

  cfirefox.settings = {
    "media.ffmpeg.vaapi.enabled" = true;
    "media.ffvpx.enabled" = false;
    "media.rdd-ffmpeg.enabled" = false;
    "media.av1.enabled" = false;
    "gfx.webrender.all" = true;
    "layers.gpu-process.enabled" = true;
    "widget.wayland.opaque-region.enabled" = false;
    "gfx.x11-egl.force-enabled" = true;
    "widget.dmabuf.force-enabled" = true;
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "555.58.02";
      sha256_64bit = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
      sha256_aarch64 = "sha256-8hyRiGB+m2hL3c9MDA/Pon+Xl6E788MZ50WrrAGUVuY=";
      openSha256 = "sha256-8hyRiGB+m2hL3c9MDA/Pon+Xl6E788MZ50WrrAGUVuY=";
      settingsSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
      persistencedSha256 = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
    };

    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    #package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
