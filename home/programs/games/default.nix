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
    gamescope
    prismlauncher
    # (lutris.override {extraPkgs = p: [p.libnghttp2];})
    winetricks
    lutris
    protontricks
  ];
}
