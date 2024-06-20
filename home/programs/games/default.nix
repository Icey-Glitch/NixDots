{
  pkgs,
  inputs,
  ...
}:
# games
{
  programs.mangohud.enable = true;
  home.packages = with pkgs; [
    inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
    #inputs.nix-gaming.packages.${pkgs.system}.viper # installs a package
    gamescope
    prismlauncher
    tetrio-desktop
    mgba
    # (lutris.override {extraPkgs = p: [p.libnghttp2];})
    winetricks
    lutris
    protontricks
  ];
}
