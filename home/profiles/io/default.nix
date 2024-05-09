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
    ../../services/ags
    ../../services/cinny.nix

    # media services
    ../../services/media/playerctl.nix
    # ../../services/media/spotifyd.nix

    # system services
    ../../services/system/kdeconnect.nix
    ../../services/system/polkit-agent.nix
    ../../services/system/power-monitor.nix
    ../../services/system/syncthing.nix
    ../../services/system/udiskie.nix

    # wayland-specific
    ../../services/wayland/hyprpaper.nix
    ../../services/wayland/hypridle.nix

    # terminal emulators
    ../../terminal/emulators/foot.nix
    ../../terminal/emulators/wezterm.nix

    # school
    ../../programs/school.nix
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-1, preferred, auto-left, auto"
      "DP-2, preferred, auto-left, auto"
      "eDP-1, preferred, auto, 1.600000"
    ];

    device = {
      name = "elan2841:00-04f3:31eb-touchpad";
      accel_profile = "custom ${accelpoints}";
      scroll_points = accelpoints;
      natural_scroll = true;
    };
  };
}
