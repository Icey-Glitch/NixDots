let
  desktop = [
    ./core/boot.nix
    ./core/default.nix

    ./hardware/fwupd.nix
    ./hardware/yubikey-gpg.nix
    ./hardware/graphics.nix

    ./network/avahi.nix
    ./network/default.nix
    ./network/tailscale.nix

    ./programs

    ./services
    ./services/greetd.nix
    ./services/pipewire.nix
    ./services/printing.nix
  ];

  laptop =
    desktop
    ++ [
      ./hardware/bluetooth.nix

      ./programs/Laptop-firefox.nix
      ./services/backlight.nix
      ./services/power.nix
      ./services/power-profiles.nix
    ];
in {
  inherit desktop laptop;
}
