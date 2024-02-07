{
  imports = [
    # editors
    ../../editors/helix
    ../../editors/neovim

    # programs
    ../../programs
    ../../programs/games
    ../../programs/wayland

    # services
    ../../services/waybar

    # system services
    ../../services/system/polkit-agent.nix
    ../../services/system/power-monitor.nix
    ../../services/system/udiskie.nix

    # wayland-specific
    ../../services/wayland/hyprpaper.nix
    ../../services/wayland/swayidle.nix

    # terminal emulators
    ../../terminal/emulators/foot.nix
  ];

  wayland.windowManager.hyprland.settings = let
    accelpoints = "0.21 0.000 0.040 0.080 0.140 0.200 0.261 0.326 0.418 0.509 0.601 0.692 0.784 0.875 0.966 1.058 1.149 1.241 1.332 1.424 1.613";
  in {
  };
}
