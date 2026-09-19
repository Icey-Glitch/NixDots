{
  environment.etc."xdg/hypr/per_host.lua".text = ''
    -----------------------------------
    ---- HOST-SPECIFIC (desktopm) -----
    -----------------------------------

    hl.monitor({
      output    = "DP-2",
      mode      = "preferred",
      position  = "auto-left",
      scale     = 1,
      transform = 1,
      vrr       = 0,
    })

    hl.monitor({
      output   = "DP-1",
      mode     = "1920x1080@240",
      position = "auto-right",
      scale    = 1,
      vrr      = 2,
    })

    hl.monitor({
      output   = "desc:Dell Inc. AW2725D CC19584",
      mode     = "2560x1440@280",
      position = "0x0",
      scale    = 1,
      bitdepth = 10,
      vrr      = 0,
    })
  '';
}
