{ self, ... }:
{
  imports = [
    # editors
    ../../editors/helix
    # ../../editors/neovim

    # programs
    ../../programs
    ../../programs/games
    ../../programs/games/slippi.nix
    ../../programs/wayland

    # services
    ../../services/waybar
    ../../services/system/yubikey-gpg.nix

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
      "DP-2, 1920x1080@240, 0x0, 1"
      "DP-1, preferred, auto-right, 1"
      "HDMI-A-1, preferred, auto-left, 1, transform, 1"
    ];
  };

  cfirefox.extraConfig = ''
    user_pref("media.ffmpeg.vaapi.enabled", false);
    user_pref("media.ffvpx.enabled", false);
    user_pref("media.rdd-ffmpeg.enabled", false);
    user_pref("media.av1.enabled", true);
    user_pref("gfx.webrender.all", true);
    user_pref("layers.gpu-process.enabled", true);
    user_pref("widget.wayland.opaque-region.enabled", false);
    user_pref("gfx.x11-egl.force-enabled", true);
    user_pref("widget.dmabuf.force-enabled", true);
    user_pref("media.hardware-video-decoding.force-enabled", true);
  '';
}
