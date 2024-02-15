{pkgs, ...}: {
  imports = [
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    betterbird
    libreoffice
    obsidian
    xournalpp
  ];
}
