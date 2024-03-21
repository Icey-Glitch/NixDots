{
  pkgs,
  inputs,
  ...
}: let
  extensions = inputs.nix-vscode-extensions.extensions.${pkgs.system};
in {
  home.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with extensions; [
      open-vsx.catppuccin.catppuccin-vsc
      open-vsx.jnoortheen.nix-ide
    ];
  };
}
