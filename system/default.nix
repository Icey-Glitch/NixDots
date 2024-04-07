let
  desktop = [
    ./core/boot.nix
    ./core/default.nix

    ./hardware/opengl.nix
    ./hardware/fwupd.nix
    ./hardware/yubikey-gpg.nix

    ./network/avahi.nix
    ./network/default.nix

    ./programs

    ./services
    ./services/greetd.nix
    ./services/pipewire.nix
  ];

  laptop =
    desktop
    ++ [
      ./hardware/bluetooth.nix

      ./services/backlight.nix
      ./services/power.nix
      ./services/power-profiles.nix
    ];
in {
  inherit desktop laptop;
}
