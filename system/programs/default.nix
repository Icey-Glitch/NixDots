{
  imports = [
    ./fonts.nix
    ./home-manager.nix
    ./obs-comp.nix
    # ./qt.nix
    ./xdg.nix
    ./school.nix
  ];

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;

    kdeconnect.enable = true;

    seahorse.enable = true;
  };
}
