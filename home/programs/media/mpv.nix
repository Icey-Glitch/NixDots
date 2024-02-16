{pkgs, ...}: {
  environment.variables.LIBVA_DRIVER_NAME = "iHD";
  programs.mpv = {
    enable = true;
    defaultProfiles = ["gpu-hq"];
    scripts = [pkgs.mpvScripts.mpris];
  };
}
