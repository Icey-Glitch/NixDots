{
  hardware.opentabletdriver.enable = true;

  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];

  programs.weylus = {
    enable = true;
    openFirewall = true;
    users = [ "icey" ];
  };
}
