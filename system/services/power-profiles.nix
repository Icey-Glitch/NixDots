{
  pkgs,
  lib,
  inputs,
  ...
}:
# run certain commands depending whether the system is on AC or on battery
let
  programs = lib.makeBinPath [inputs.hyprland.packages.${pkgs.system}.default];

  unplugged = pkgs.writeShellScript "unplugged" ''
    export PATH=$PATH:${programs}
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 /tmp/hypr | tail -1)

    hyprctl --batch 'keyword decoration:drop_shadow 0 ; keyword animations:enabled 0'
    cpupower frequency-set -g powersave
  '';

  plugged = pkgs.writeShellScript "plugged" ''
    export PATH=$PATH:${programs}
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 /tmp/hypr | tail -1)

    hyprctl --batch 'keyword decoration:drop_shadow 1 ; keyword animations:enabled 1'
    cpupower frequency-set -g performance
  '';
in {
  services.throttled = {
    enable = true;
    extraConfig = ''
      [UNDERVOLT]
      # CPU core voltage offset (mV)
      CORE: -105
      # Integrated GPU voltage offset (mV)
      GPU: -85
      # CPU cache voltage offset (mV)
      CACHE: -105
      # System Agent voltage offset (mV)
      UNCORE: -85
      # Analog I/O voltage offset (mV)
      ANALOGIO: 0
    '';
  };
  services.udev.extraRules = ''
    # start/stop services on power (un)plug
    SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${plugged}"
    SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${unplugged}"
  '';
}
