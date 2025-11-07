{ pkgs, ... }:
{
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-esr;
    profiles = {
      BetterBird = {
        isDefault = true;
      };
    };
  };
}
