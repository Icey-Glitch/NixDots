{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./browsers/chromium.nix
    ./browsers/firefox.nix
    #  ./browsers/zen.nix
    ./media
    ./gtk.nix
    ./office
    ./qt.nix
    ./vicinae
  ];

  home.packages = with pkgs; [
    halloy
    signal-desktop
    # telegram-desktop
    nheko

    gnome-calculator
    gnome-control-center

    overskride
    resources
    wineWow64Packages.wayland

    zotero
  ];
}
