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
  powerManagement.powertop.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };
}
