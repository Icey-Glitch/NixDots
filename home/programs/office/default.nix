{pkgs, ...}: {
  imports = [
    ./zathura.nix
    ./vscodium.nix
    ./obs.nix
    ./webcord.nix
  ];

  home.packages = with pkgs; [
    keepassxc
    betterbird
    libreoffice
    obsidian
    xournalpp
  ];
}
