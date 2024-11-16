{pkgs, ...}: {
  hardware = {
    gpgSmartcards.enable = true;
  };

  services = {
    dbus.packages = [pkgs.grc];
    udev.packages = with pkgs; [
      yubikey-personalization
      libu2f-host
    ];
    pcscd = {
      enable = true;
      # Automatically start on YubiKey insert
      plugins = [pkgs.ccid];
    };
  };
}
