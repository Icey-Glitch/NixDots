{
  inputs,
  pkgs,
  config,
  stdenv,
  ...
}:
{
  # themable spotify
  imports = [
    inputs.spicetify-nix.homeManagerModule
  ];

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;
      variant = if config.theme.name == "light" then "latte" else "mocha";
    in
    {
      enable = true;

      theme = spicePkgs.themes.catppuccin;

      colorScheme = variant;

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        history
        hidePodcasts
        shuffle
      ];
    };
}
