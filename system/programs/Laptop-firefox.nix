{
  config,
  self,
  pkgs,
  ...
}: {
  imports = [self.nixosModules.cfirefox];
  cfirefox.extraConfig = ''
    user_pref("layout.css.devPixelsPerPx", "1.5");
  '';
}
