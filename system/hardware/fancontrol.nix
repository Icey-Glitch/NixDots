{ pkgs, ... }:
{
  # Nuvoton NCT6798D Super-I/O (ASUS ROG Maximus XI Hero).
  # CoolerControl can auto-detect/load this, but pinning it makes the
  # pwm1-7 channels deterministic across boots.
  boot.kernelModules = [
    "coretemp"
    "nct6775"
  ];

  environment.systemPackages = with pkgs; [
    lm_sensors
    liquidctl
  ];

  # GUI + daemon. Handles motherboard hwmon, NVIDIA GPUs (NVML) and
  # liquidctl devices (NZXT Kraken).
  programs.coolercontrol.enable = true;
}
