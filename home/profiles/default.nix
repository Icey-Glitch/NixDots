{
  "icey@thinkpad" = [
    ../.
    ./thinkpad
  ];
  "icey@macbook" = [
    ../.
    ./macbook
  ];
  "icey@io" = [
    ../.
    ./io
  ];
  "icey@desktopm" = [
    ../.
    ./desktopm
  ];
  "icey@server" = [
    ../.
    ./server
  ];
  # xenhost is headless (Xen dom0 + DRAKVUF research box) -- self-contained
  # profile, deliberately not routed through the shared ../. base (see
  # home/profiles/xenhost/default.nix for why).
  "icey@xenhost" = [
    ./xenhost
  ];
}
