{pkgs, ...}: {
  imports = [
    ./zathura.nix
    ./vscodium.nix
  ];

  home.packages = with pkgs; [
    keepassxc
    streamlink-twitch-gui-bin
    betterbird
    libreoffice
    obsidian
    xournalpp
  ];
}
