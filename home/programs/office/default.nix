{pkgs, ...}: {
  imports = [
    ./betterbird.nix
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
    cups
    #ansel
    hunspell
    #element-desktop
    hunspellDicts.en_US-large
    qbittorrent
    libreoffice
    obsidian
    rnote
    xournalpp
  ];
}
