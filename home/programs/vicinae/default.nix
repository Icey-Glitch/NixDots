{ inputs, pkgs, ... }:
{
  imports = [ inputs.vicinae.homeManagerModules.default ];

  programs.vicinae = {
    enable = true;
    systemd.enable = true;

    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      # bluetooth
      nix
      wifi-commander
    ];
  };
}
