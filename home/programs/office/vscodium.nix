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
    ];
    userSettings = {
      # Workbench
      "window.menuBarVisibility" = "toggle";
      "workbench.sideBar.location" = "left";
      "window.autoDetectColorScheme" = true;
      "workbench.list.smoothScrolling" = true;
      "workbench.editor.labelFormat" = "short";
      "workbench.startupEditor" = "newUntitledFile";
      # Font
      "editor.fontFamily" = "JetBrainsMono Nerd Font Mono";

      # Format
      "beautify.onSave" = true;

      "editor.formatOnSave" = true;

      "workbench.colorTheme" = "Catppuccin Macchiato";
    };
  };
}
