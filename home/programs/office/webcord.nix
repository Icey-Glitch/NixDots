{
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = [
    inputs.arrpc.packages.${pkgs.system}.arrpc
    pkgs.vesktop
  ];

  # enable arRPC service, adds arRPC to home-packages and starts the systemd service for you
  services.arrpc.enable = true;
}
