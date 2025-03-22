{
  pkgs,
  inputs,
  ...
}:
# games
{
  programs.mangohud.enable = true;
  home.packages = with pkgs; [
    # Default latency sometimes crackles
    (inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin.override {pipewire_latency = "128/48000";})
    #inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
    #inputs.nix-gaming.packages.${pkgs.system}.viper # installs a package
    gamescope
    prismlauncher
    tetrio-desktop
    mgba
    (lutris.override {extraPkgs = p: [p.libnghttp2];})
    winetricks
  ];
}
