{pkgs, ...}: {
  # Enable GPG agent with SSH support
  programs.gpg = {
    enable = true;
  };

  services = {
    # Dedicated agent for handling GPG and SSH
    gpg-agent = {
      enable = true;
      enableSshSupport = true;

      enableZshIntegration = true;

      sshKeys = [
        "FD29D681EB71B310BD8123D8DF8D43E8039E0105"
      ];

      # Increase cache TTL for better usability
      defaultCacheTtl = 3600;
      defaultCacheTtlSsh = 3600;
      maxCacheTtl = 28800;
      maxCacheTtlSsh = 28800;
      # Enable extra socket for SSH support
      enableExtraSocket = true;
      enableScDaemon = true;

      # Use pinentry for passphrase entry
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";

    # pinentry for GPG passphrase entry
    GPG_TTY = "/dev/tty";
  };

  programs.ssh = {
    enable = true;
    #agentPKCS11Whitelist = "${pkgs.opensc}/lib/opensc-pkcs11.so";
    extraConfig = ''
      Host *
        RemoteForward /run/user/1000/gnupg/S.gpg-agent /run/user/1000/gnupg/S.gpg-agent.extra
        RemoteForward /run/user/1000/gnupg/S.gpg-agent.ssh /run/user/1000/gnupg/S.gpg-agent.ssh
    '';
    forwardAgent = true;
  };

  home.packages = with pkgs; [
    gnupg
    # YubiKey management tools
    yubikey-manager # CLI tool
    #yubikey-manager-qt # GUI tool
    yubikey-personalization # CLI personalization tool

    yubico-piv-tool # PIV-related operations
    yubioath-flutter # OATH (2FA) management

    # Additional useful tools
    paperkey # Backup GPG keys on paper
    pcsctools # Smart card utilities
    opensc # Smart card framework
  ];
}
