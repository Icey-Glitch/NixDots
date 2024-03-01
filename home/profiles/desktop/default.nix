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
    ../../services/system/udiskie.nix

    # wayland-specific
    ../../services/wayland/hyprpaper.nix
    ../../services/wayland/hypridle.nix

    # terminal emulators
    ../../terminal/emulators/foot.nix
  ];

}
