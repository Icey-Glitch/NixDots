{pkgs, ...}: {
  imports = [
    ./zathura.nix
    ./vscodium.nix
    ./obs.nix
    ./webcord.nix
  ];

  home.packages = with pkgs; [
    iaito
    maestral
    keepassxc
    iaito
    hunspell
    hunspellDicts.en_US-large
    betterbird
    qbittorrent
    libreoffice
    obsidian
    xournalpp
  ];
}
