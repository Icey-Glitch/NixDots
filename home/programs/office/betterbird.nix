{pkgs, ...}: {
  programs.thunderbird = {
    enable = true;
    package = pkgs.betterbird;
    profiles = {
      BetterBird = {
        isDefault = true;
      };
    };
  };
}
