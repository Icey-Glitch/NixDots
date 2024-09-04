{lib, ...}: {
  # nh default flake
  environment.variables.FLAKE = lib.mkForce "/home/icey/Git/newdots/NixDots";

  programs.nh = {
    enable = true;
    # weekly cleanup
    clean = {
      enable = true;
      extraArgs = "--keep-since 30d";
    };
  };
}
