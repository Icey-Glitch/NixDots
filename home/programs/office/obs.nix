{pkgs, ...}: {
  programs.obs-studio = {
    enable = true;

    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };

    plugins = [
      pkgs.obs-studio-plugins.wlrobs
      #pkgs.obs-studio-plugins.virtualcam
      #pkgs.obs-studio-plugins.droidcam-obs
    ];
  };
}
