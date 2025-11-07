{ pkgs, ... }:
{
  services = {
    printing = {
      enable = true;
      drivers = [
        pkgs.splix
        pkgs.gutenprintBin
      ];
    };
  };
}
