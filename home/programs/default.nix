{pkgs, ...}: {
  imports = [
    ./anyrun
    ./browsers/chromium.nix
    ./browsers/firefox.nix
    ./media
    ./gtk.nix
    ./office
  ];

  home.packages = with pkgs; [
    tdesktop
    vesktop

    overskride
    mission-center
    wineWowPackages.wayland
  ];
}
