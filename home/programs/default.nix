{pkgs, ...}: {
  imports = [
    ./anyrun
    ./browsers/chromium.nix
    ./browsers/firefox.nix
    ./media
    ./gtk.nix
    ./office
    ./waybar
  ];

  home.packages = with pkgs; [
    tdesktop
  ];
}
