{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-symbols

      # Sans(Serif) fonts
      libertinus
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      roboto
      (google-fonts.override {fonts = ["Inter"];})

      # nerdfonts
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
    ];

    # causes more issues than it solves
    enableDefaultPackages = false;

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = let
      addAll = builtins.mapAttrs (_: v: v ++ ["Noto Color Emoji"]);
    in
      addAll {
        serif = ["Libertinus Serif"];
        sansSerif = ["Inter"];
        monospace = ["JetBrainsMono Nerd Font"];
        emoji = [];
      };
  };
}
