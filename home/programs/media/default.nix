{pkgs, ...}:
# media - control and enjoy audio/video
{
  imports = [
    ./mpv.nix
    ./rnnoise.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pulsemixer
    pwvucontrol
    helvum

    # audio
    tauon
    amberol
    spotify
    nicotine-plus

    # Streamio
    stremio
    syncplay

    # Twitch
    streamlink-twitch-gui-bin
    chatterino2

    # images
    loupe

    # videos
    celluloid

    # torrents
    transmission_4-gtk
  ];
}
