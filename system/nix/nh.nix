{
  # nh default flake
  environment.variables.FLAKE = "/home/icey/Git/newdots/NixDots";

  programs.nh = {
    enable = true;
    # weekly cleanup
    clean = {
      enable = true;
      extraArgs = "--keep-since 30d";
    };
  };
}
