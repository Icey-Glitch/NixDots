let
  desktop = [
    ./core
    ./core/boot.nix

    ./hardware/fwupd.nix
    ./hardware/smartcard.nix

    ./hardware/graphics.nix

    ./network
    ./network/avahi.nix
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
