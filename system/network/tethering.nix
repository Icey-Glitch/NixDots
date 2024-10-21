{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    libimobiledevice
    ifuse # optional, to mount using 'ifuse'
  ];

  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };
}
