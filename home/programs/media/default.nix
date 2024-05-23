{pkgs, ...}:
# media - control and enjoy audio/video
{
  imports = [
    ./mpv.nix
    ./rnnoise.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pavucontrol
    pulsemixer

    # audio
    tauon
    amberol
    spotify

    # Streamio
    stremio

    # Twitch
    #streamlink-twitch-gui-bin
    chatterino2

    # images
    loupe

    # videos
    celluloid
  ];
}
