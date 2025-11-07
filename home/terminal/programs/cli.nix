{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar

    # misc
    chafa
    libnotify
    inetutils
    sshfs

    # utils
    aria2
    dust
    duf
    fd
    jq
    file
    jaq
    ripgrep
    ripdrag
  ];

  programs = {
    eza.enable = true;

    ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        # default ssh config
        "*" = {
          addKeysToAgent = "no";
          certificateFile = [ ];
          checkHostIP = true;
          compression = false;
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
          dynamicForwards = [ ];
          extraOptions = { };
          forwardX11 = false;
          forwardX11Trusted = false;
          hashKnownHosts = false;
          identitiesOnly = false;
          identityAgent = [ ];
          identityFile = [ ];
          localForwards = [ ];
          remoteForwards = [ ];
          sendEnv = [ ];
          serverAliveCountMax = 3;
          serverAliveInterval = 0;
          setEnv = { };
          userKnownHostsFile = "~/.ssh/known_hosts";
        };
      };
    };
  };
}
