{pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez5-experimental;
    settings = {
      # make Xbox Series X controller work
      General = {
        Enable = "Source,Sink,Media,Socket";
        Class = "0x000100";
        ControllerMode = "bredr";
        FastConnectable = true;
        JustWorksRepairing = "always";
        Privacy = "device";
        # Battery info for Bluetooth devices
        Experimental = true;
      };
    };
  };

  services.pipewire.wireplumber.extraConfig.bluetooth."51-bluez-config" = ''
    bluez_monitor.properties = {
    	["bluez5.enable-sbc-xq"] = true,
    	["bluez5.enable-msbc"] = true,
    	["bluez5.enable-hw-volume"] = true,
    	["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag a2dp_sink a2dp_source]"
    }
  '';

  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = ["network.target" "sound.target"];
    wantedBy = ["default.target"];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

  # https://github.com/NixOS/nixpkgs/issues/114222
  systemd.user.services.telephony_client.enable = false;
}
