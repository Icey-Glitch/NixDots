{pkgs, ...}: {
  imports = [
    ./zathura.nix
    ./vscodium.nix
  ];

  home.packages = with pkgs; [
    keepassxc
    betterbird
    libreoffice
    obsidian
    xournalpp
  ];
}
