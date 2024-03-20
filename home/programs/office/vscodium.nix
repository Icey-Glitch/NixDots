{
  pkgs,
  config,
  inputs,
  system,
  ...
}: let
  extensions = inputs.nix-vscode-extensions.extensions.${pkgs.system};
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with extensions; [
      open-vsx.catppuccin.catppuccin-vsc
    ];
  };
}
