{
  imports = [
    # editors
    ../../editors/helix
    # ../../editors/neovim

    # programs
    ../../programs
    ../../programs/games
    ../../programs/wayland

    # services
    ../../services/waybar

    # system services
    ../../services/system/polkit-agent.nix
    ../../services/system/udiskie.nix

    # wayland-specific
    #    ../../services/wayland/gammastep.nix
    ../../services/wayland/hyprpaper.nix
    ../../services/wayland/hypridle.nix

    # terminal emulators
    ../../terminal/emulators/foot.nix
    ../../terminal/emulators/wezterm.nix
  ];
  wayland.windowManager.hyprland.settings = {
    cursor = {
      no_hardware_cursors = true;
    };
    monitor = [
      "DP-3, preferred, 1920x0, 1"
      "DP-1, 1920x1080@240, 0x0, 1"
      "HDMI-A-1, preferred, -1080x0, 1, transform, 1"
    ];
  };
}
