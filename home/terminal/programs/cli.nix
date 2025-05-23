{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar

    # misc
    libnotify
    inetutils
    sshfs

    # utils
    aria
    du-dust
    duf
    fd
    jq
    file
    jaq
    ripgrep
  ];

  programs = {
    eza.enable = true;
    ssh = {
      enable = true;

      matchBlocks."cloudut" = {
        hostname = "10.20.7.115";
        user = "cloud7115";
        identityFile = "${config.home.homeDirectory}/.ssh/cloud7115_id_ed25519";
      };
    };
  };
}
