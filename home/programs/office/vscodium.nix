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
      vscode-marketplace-release.github.copilot
      vscode-marketplace-release.github.copilot-chat
      open-vsx.catppuccin.catppuccin-vsc
      open-vsx.jnoortheen.nix-ide
    ];
    userSettings = {
      # Workbench
      "window.menuBarVisibility" = "toggle";
      "workbench.sideBar.location" = "left";
      "window.autoDetectColorScheme" = false;
      "workbench.list.smoothScrolling" = true;
      "workbench.editor.labelFormat" = "short";
      "workbench.startupEditor" = "newUntitledFile";

      # extensions
      "extensions.autoCheckUpdates" = false;
      "extensions.autoUpdate" = false;
      "extensions.experimental.deferredStartupFinishedActivation" = true;
      "extensions.ignoreRecommendations" = true;

      # Editor
      "editor.experimental.asyncTokenization" = true;
      "editor.minimap.enabled" = false;

      # Font
      "editor.fontFamily" = "JetBrainsMono Nerd Font Mono";

      # Format
      "beautify.onSave" = true;

      "editor.formatOnSave" = true;

      "workbench.colorTheme" = "Catppuccin Macchiato";

      # for nix
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
        # settings for 'nixd' LSP
        "nil" = {
          "diagnostics" = {
            "ignored" = [
              "unused_binding"
              "unused_with"
            ];
          };
          "formatting" = {
            "command" = [
              "alejandra"
            ];
          };
        };
      };
    };
  };
}
