{
  services.gammastep = {
    enable = true;
    tray = true;

    # stopgap until geoclue's wifi location is fixed
    provider = "manual";
    latitude = 45.4;
    longitude = -122.8;

    enableVerboseLogging = true;

    temperature = {
      day = 6500;
      night = 4000;
    };

    settings.general.adjustment-method = "wayland";
  };
}
