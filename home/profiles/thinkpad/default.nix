{lib, ...}: {
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
    ../../services/system/yubikey-gpg.nix

    # system services
    ../../services/system/polkit-agent.nix
    ../../services/system/udiskie.nix

    # wayland-specific
    ../../services/wayland/hyprpaper.nix
    ../../services/wayland/hypridle.nix

    # terminal emulators
    ../../terminal/emulators/foot.nix
  ];

  wayland.windowManager.hyprland.settings = {
    misc = {
      vrr = lib.mkForce 2;
      vfr = true;
    };
    monitor = [
      "eDP-1, 1920x1080@60.02, 0x0, 1.5"
    ];
    decoration = {
      blur.enabled = lib.mkForce false;
      shadow.enabled = lib.mkForce false;
    };
  };
  cfirefox.extraConfig = ''
    user_pref("layout.css.devPixelsPerPx", "1.5");
  '';
}
