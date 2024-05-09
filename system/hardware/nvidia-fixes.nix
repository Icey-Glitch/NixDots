{
  config,
  pkgs,
  ...
}: {
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    ## hw decoding
    EGL_PLATFORM = "wayland";
    NVD_BACKEND = "direct";

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
      libvdpau-va-gl
    ];
  };

  #  boot.extraModprobeConfig = ''
  #    options nvidia NVreg_RegistryDwords="PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3"
  #  '';

  nixpkgs.overlays = [
    (_: final: {
      wlroots_0_16 = final.wlroots_0_16.overrideAttrs (_: {
        patches = [
          ./patches/wlroots-nvidia.patch
          ./patches/wlroots-screenshare.patch
        ];
      });
    })
  ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "550.67";
      sha256_64bit = "sha256-mSAaCccc/w/QJh6w8Mva0oLrqB+cOSO1YMz1Se/32uI=";
      sha256_aarch64 = "sha256-+UuK0UniAsndN15VDb/xopjkdlc6ZGk5LIm/GNs5ivA=";
      openSha256 = "sha256-M/1qAQxTm61bznAtCoNQXICfThh3hLqfd0s1n1BFj2A=";
      settingsSha256 = "sha256-FUEwXpeUMH1DYH77/t76wF1UslkcW721x9BHasaRUaM=";
      persistencedSha256 = "sha256-ojHbmSAOYl3lOi2X6HOBlokTXhTCK6VNsH6+xfGQsyo=";
    };

    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    #package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
