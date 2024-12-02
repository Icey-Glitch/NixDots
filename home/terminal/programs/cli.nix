{pkgs, ...}: {
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
    ssh.enable = true;
  };
}
