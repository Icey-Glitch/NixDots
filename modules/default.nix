{
  flake.modules = {
    theme = import ./theme;
    cfirefox = import ./firefox;
    virt = import ./virtualisation;
  };
}
