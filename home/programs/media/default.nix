{ pkgs, self, ... }:
# media - control and enjoy audio/video
{
  imports = [
    ./mpv.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pulsemixer
    pwvucontrol
    crosspipe

    # audio
    tauon
    amberol
    spotify
    nicotine-plus

    # Streamio
    # stremio
    syncplay
    supersonic

    # Twitch
    streamlink-twitch-gui-bin
    chatterino2

    # images
    loupe

    # videos
    celluloid
    self.packages.${pkgs.stdenv.hostPlatform.system}.stremio-linux-shell

    # torrents
    transmission_4-gtk
  ];
}
