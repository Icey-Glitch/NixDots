{ inputs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];
  # nh default flake
  environment.variables.NH_FLAKE = "/home/icey/Documents/code/dotfiles";

  wsl = {
    enable = true;
    defaultUser = "icey";
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
