{pkgs, ...}: {
  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  services = {
    udev.packages = with pkgs; [
      yubikey-personalization
    ];
    pcscd.enable = true;
  };

  hardware.gpgSmartcards.enable = true;

  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  environment.systemPackages = with pkgs; [
    gnupg
    # Yubico's official tools
    yubikey-manager # cli
    yubikey-manager-qt # gui
    yubikey-personalization # cli
    yubikey-personalization-gui # gui
    yubico-piv-tool # cli
    yubioath-flutter # gui
  ];
}
