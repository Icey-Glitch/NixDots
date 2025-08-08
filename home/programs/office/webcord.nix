{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];
  home.packages = [
    inputs.arrpc.packages.${pkgs.system}.arrpc
  ];

  programs.nixcord = {
    enable = true;
    vesktop.enable = true;
    config = {
      themeLinks = [
        "https://raw.githubusercontent.com/LuckFire/amoled-cord/main/clients/amoled-cord.theme.css"
      ];
      plugins = {
        fakeNitro.enable = true;
        fixImagesQuality.enable = true;
        messageLogger.enable = true;
        validUser.enable = true;
        volumeBooster.enable = true;
      };
    };
  };

  # enable arRPC service, adds arRPC to home-packages and starts the systemd service for you
  services.arrpc.enable = true;
}
