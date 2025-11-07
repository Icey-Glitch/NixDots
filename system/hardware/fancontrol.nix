{ pkgs, ... }:
{
  boot.kernelModules = [ "coretemp" ]; # or appropriate sensor module

  environment.systemPackages = with pkgs; [
    lm_sensors
  ];

  programs.coolercontrol = {
    enable = true;
    nvidiaSupport = true;
  };
}
