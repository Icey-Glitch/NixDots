{lib, ...}: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;

    wireplumber.extraConfig."wireplumber.profiles".main."monitor.libcamera" = "disabled";
  };

  hardware.pulseaudio.enable = lib.mkForce false;

  # This is needed for some unknon reason at this time because "something" is setting this to a non boolean value
  services.pulseaudio.enable = lib.mkForce false;
}
