{
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.git;
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOjRbqTrh6+HfoCy6kwBQFJLcLawY8beWhUWsvcaoDhr Icey";
in {
  home.packages = [
    pkgs.gh
  ];

  # enable scrolling in git diff
  home.sessionVariables.DELTA_PAGER = "less -R";

  programs.git = {
    enable = true;

    #delta = {
    #  enable = true;
    #  options.dark = true;
    #};

    extraConfig = {
      diff.colorMoved = "default";
      merge.conflictstyle = "diff3";
    };

    aliases = let
      log = "log --show-notes='*' --abbrev-commit --pretty=format:'%Cred%h %Cgreen(%aD)%Creset -%C(bold red)%d%Creset %s %C(bold blue)<%an>% %Creset' --graph";
    in {
      a = "add --patch"; # make it a habit to consciosly add hunks
      ad = "add";

      b = "branch";
      ba = "branch -a"; # list remote branches
      bd = "branch --delete";
      bdd = "branch -D";

      c = "commit";
      ca = "commit --amend";
      cm = "commit --message";

      co = "checkout";
      cb = "checkout -b";
      pc = "checkout --patch";

      cl = "clone";

      d = "diff";
      ds = "diff --staged";

      h = "show";
      h1 = "show HEAD^";
      h2 = "show HEAD^^";
      h3 = "show HEAD^^^";
      h4 = "show HEAD^^^^";
      h5 = "show HEAD^^^^^";

      p = "push";
      pf = "push --force-with-lease";

      pl = "pull";

      l = log;
      lp = "${log} --patch";
      la = "${log} --all";

      r = "rebase";
      ra = "rebase --abort";
      rc = "rebase --continue";
      ri = "rebase --interactive";

      rs = "reset";
      rsh = "reset --hard";

      s = "status --short --branch";
      ss = "status";

      st = "stash";
      stc = "stash clear";
      sth = "stash show --patch";
      stl = "stash list";
      stp = "stash pop";

      forgor = "commit --amend --no-edit";
      oops = "checkout --";
    };

    ignores = ["*~" "*.swp" "*result*" ".direnv" "node_modules"];

    signing = {
      key = "A984A90CB698A0B5";
      signByDefault = true;
      #  format = "ssh";
    };

    extraConfig = {
      gpg = {
        #format = "ssh";
        #ssh.allowedSignersFile = config.home.homeDirectory + "/" + config.xdg.configFile."git/allowed_signers".target;
      };

      #credential.helper = "${
      #  pkgs.git.override {withLibsecret = true;}
      #}/bin/git-credential-libsecret";

      pull.rebase = true;
    };

    userEmail = "Icey-Glitch@riseup.net";
    userName = "Icey-Glitch";
  };

  xdg.configFile."git/allowed_signers".text = ''
    ${cfg.userEmail} namespaces="git" ${key}
  '';
}
