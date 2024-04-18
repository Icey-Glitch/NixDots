{pkgs, ...}: {
  imports = [
    ./zathura.nix
    ./vscodium.nix
    ./obs.nix
  ];

  home.packages = with pkgs; [
    keepassxc
    betterbird
    libreoffice
    obsidian
    xournalpp
  ];
}
