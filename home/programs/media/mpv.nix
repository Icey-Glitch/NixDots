{
  pkgs,
  lib,
  ...
}:
let
  mpvShaders = {
    FSR = pkgs.fetchurl {
      url = "https://gist.githubusercontent.com/agyild/82219c545228d70c5604f865ce0b0ce5/raw/4ef91348ab4ade0ef74c6c487df27cf31bdc69ae/FSR.glsl";
      hash = "sha256-Kzfj42SJ3+l8ZSlckJechUEPJUpAtVnWNM4zvBVMDTE=";
    };
    SSimDownscaler = pkgs.fetchurl {
      url = "https://gist.githubusercontent.com/igv/36508af3ffc84410fe39761d6969be10/raw/575d13567bbe3caa778310bd3b2a4c516c445039/SSimDownscaler.glsl";
      hash = "sha256-AEq2wv/Nxo9g6Y5e4I9aIin0plTcMqBG43FuOxbnR1w=";
    };
    HdeDeband = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/AN3223/dotfiles/61d10e7bb50b5813beed72d206d49c6840bd3486/.config/mpv/shaders/hdeband.glsl";
      hash = "sha256-vMoGC1v0bK99rHt0OSvCgXucw9T8X8reSa814rBDKz0=";
    };
    hdrToys = pkgs.fetchzip {
      url = "https://github.com/natural-harmonia-gropius/hdr-toys/archive/refs/heads/master.zip";
      hash = "sha256-cXa4hXJh083vvkgZG1qkHShxfm1ErQ3xahHrhQCfRCc=";
    };
  };
in
{
  programs.yt-dlp = {
    enable = true;
    settings = {
      embed-chapters = true;
      embed-metadata = true;
      embed-thumbnail = true;
      convert-thumbnail = "jpg";
      embed-subs = true;
      sub-langs = "all";
      downloader = "aria2c";
      downloader-args = "aria2c:'-c -x16 -s16 -k2M'";
      download-archive = "yt-dlp-archive.txt";
    };
  };

  xdg.configFile."mpv/shaders/hdr-toys".source = mpvShaders.hdrToys + "/shaders/hdr-toys";

  programs.mpv = {
    enable = true;
    defaultProfiles = [ "high-quality" ];

    bindings = {
      WHEEL_UP = "seek 10";
      WHEEL_DOWN = "seek -10";
      "ALT+k" = "add sub-scale +0.1";
      "ALT+j" = "add sub-scale -0.1";
      "Alt+0" = "set window-scale 0.5";
      "Ctrl+F" = "script-binding quality_menu/video_formats_toggle";
      "Alt+f" = "script-binding quality_menu/audio_formats_toggle";
      "Ctrl+R" = "script-binding reload/reload";
      "CTRL+b" = "cycle deband";
      "Ctrl+Shift+F6" =
        "no-osd change-list glsl-shaders set \"${mpvShaders.HdeDeband}\"; show-text \"Deband: ON\"";
      "Ctrl+Shift+F7" =
        "no-osd change-list glsl-shaders set \"${mpvShaders.FSR}\"; show-text \"FSR: ON\"";
      "Ctrl+Shift+F8" =
        "no-osd change-list glsl-shaders set \"${mpvShaders.SSimDownscaler}\"; show-text \"SSimDown: ON\"";
      "Ctrl+Shift+\\" = "no-osd change-list glsl-shaders clr \"\"; show-text \"GLSL shaders cleared\"";
    };

    config = {
      # General
      keep-open = true;
      snap-window = true;
      cursor-autohide = 100;
      save-position-on-quit = true;
      autofit = "85%x85%";
      border = false;
      msg-module = true;
      video-sync = "display-resample";

      # OSD
      osc = false;
      osd-bar = false;
      osd-font = "'Inter Tight Medium'";
      osd-font-size = 30;
      osd-color = "#CCFFFFFF";
      osd-border-color = "#DD322640";
      osd-border-size = 2;

      # Audio
      ao = "pipewire";
      af = "acompressor=ratio=4,loudnorm";
      audio-pitch-correction = true;

      # Video backend
      vo = "gpu-next";
      gpu-api = "vulkan";
      gpu-context = "waylandvk";
      hwdec = "nvdec-copy";
      target-colorspace-hint = "yes";

      # Vulkan
      vulkan-swap-mode = "fifo";
      gpu-shader-cache-dir = "~/.cache/mpv/shadercache";

      # Disable color interference globally
      icc-profile-auto = false;

      # Dither / scaling (safe for HDR)
      dither-depth = "auto";
      temporal-dither = "yes";
      dither = "fruit";

      deband = false;
      scale-antiring = 0.6;
      dscale-antiring = 0.7;
      cscale-antiring = 0.7;

      interpolation = false;
      linear-upscaling = true;
      sigmoid-upscaling = true;
      correct-downscaling = true;

      dscale = "lanczos";
      cscale = "lanczos";

      demuxer-max-back-bytes = "100MiB";
      demuxer-max-bytes = 104857600;
    };

    profiles = {
      "hdr-force" = {
        # Force HDR output
        target-prim = "bt.2020";
        target-trc = "pq";

        # Declare HDR mastering / peak
        hdr-compute-peak = "yes";
        hdr-peak-percentile = 99.9;
        hdr-peak-decay-rate = 20;

        # Do NOT tone-map (we want HDR passthrough)
        tone-mapping = "auto";

        # Ensure 10-bit path
        dither-depth = 10;

        # Vulkan / Wayland stability
        vulkan-swap-mode = "mailbox";

        # Prevent mpv from second-guessing
        target-colorspace-hint = "no";
        icc-profile-auto = "no";

        # Debug (optional but useful)
        msg-level = "vo=trace,gpu=trace";
      };
    };

    scripts = [
      pkgs.mpvScripts.mpris
      pkgs.mpvScripts.uosc
      pkgs.mpvScripts.thumbfast
      pkgs.mpvScripts.sponsorblock
      pkgs.mpvScripts.quality-menu
      pkgs.mpvScripts.webtorrent-mpv-hook
    ];
  };
}
