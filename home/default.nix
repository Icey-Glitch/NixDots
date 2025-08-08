{
  self,
  inputs,
  ...
}: {
  imports = [
    ./specialisations.nix
    ./terminal
    inputs.nur.modules.homeManager.default
    #inputs.betterfox.hmModules.default
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.nix-index-db.homeModules.nix-index
    inputs.tailray.homeManagerModules.default
    self.nixosModules.theme
  ];

  home = {
    username = "icey";
    homeDirectory = "/home/icey";
    stateVersion = "23.11";
    extraOutputsToInstall = ["doc" "devdoc"];
  };

  # disable manuals as nmd fails to build often
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  catppuccin.flavor = "macchiato";

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;
}
