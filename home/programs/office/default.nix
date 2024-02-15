{pkgs, ...}: {
  imports = [
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    keepassxc
    betterbird
    libreoffice
    obsidian
    xournalpp
  ];
}
