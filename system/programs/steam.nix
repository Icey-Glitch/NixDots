{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    platformOptimizations.enable = true;

    extraCompatPackages = [
      inputs.nix-gaming.packages.${pkgs.system}.northstar-proton
      pkgs.proton-ge-bin
    ];

    # fix gamescope inside steam
    package = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          gamescope
          mangohud
          keyutils
          libkrb5
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
        ];
    };
  };
}
