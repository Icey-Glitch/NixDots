# networking configuration
{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./optimize.nix
    ./tethering.nix
  ];

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
    wifi.powersave = true;
  };

  programs.ssh.extraConfig = ''
    Host desktopm
      HostName desktopm.homenet
  '';

  services = {
    openssh = {
      enable = true;

      settings = {
        StreamLocalBindUnlink = "yes";
        UseDns = true;
      };
    };

    mullvad-vpn.enable = true;

    # DNS resolver
    resolved = {
      enable = true;
      dnsovertls = "opportunistic";
    };
  };

  systemd.services.NetworkManager-wait-online.serviceConfig.ExecStart = ["" "${pkgs.networkmanager}/bin/nm-online -q"];
}
