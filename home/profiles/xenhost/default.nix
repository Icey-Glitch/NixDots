# Minimal, self-contained home-manager profile for xenhost -- deliberately
# does NOT route through home/default.nix (the shared base every other
# host's profile uses): that pulls in home/terminal/programs (which hits a
# real home-manager option incompatibility, home-manager.users.icey.
# programs.ssh.settings no longer existing -- confirmed via
# `nixos-rebuild build`, not guessed), plus theming/tailray/nix-index-db
# that a headless research box doesn't need anyway. This gets exactly what
# was actually asked for -- the same shell as every other host -- without
# any of that.
{ config, ... }:
{
  imports = [
    ../../terminal/shell/zsh.nix
    ../../terminal/shell/starship.nix
    ../../terminal/shell/zoxide.nix
  ];

  home = {
    username = "icey";
    homeDirectory = "/home/icey";
    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;
}
