# networking configuration
{
  lib,
  pkgs,
  ...
}:
{
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

    # DNS resolver
    resolved = {
      enable = true;
      # Disable until https://github.com/NixOS/nixpkgs/issues/440073 is fixed
      # Waiting for https://github.com/NixOS/nixpkgs/pull/440130 to land in nixos-unstable
      # dnsovertls = "opportunistic";
    };
  };

  systemd.services.NetworkManager-wait-online.serviceConfig.ExecStart = [
    ""
    "${pkgs.networkmanager}/bin/nm-online -q"
  ];
}
