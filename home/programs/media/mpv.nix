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

  # Source HDR toys to the standard location
  xdg.configFile."mpv/shaders/hdr-toys".source = mpvShaders.hdrToys + "/shaders/hdr-toys";

  programs.mpv = {
    enable = true;
    defaultProfiles = [ "high-quality" ];

    bindings = {
      # Mouse and Scale
      WHEEL_UP = "seek 10";
      WHEEL_DOWN = "seek -10";
      "ALT+k" = "add sub-scale +0.1";
      "ALT+j" = "add sub-scale -0.1";
      "Alt+0" = "set window-scale 0.5";

      # Quality & Reload
      "Ctrl+f" = "script-binding quality_menu/video_formats_toggle";
      "Alt+f" = "script-binding quality_menu/audio_formats_toggle";
      "Ctrl+r" = "script-binding reload/reload";

      # Shaders Toggles
      "CTRL+b" = "cycle deband";
      "Ctrl+Shift+F6" =
        "no-osd change-list glsl-shaders set \"${mpvShaders.HdeDeband}\"; show-text \"Deband: ON\"";
      "Ctrl+Shift+F7" =
        "no-osd change-list glsl-shaders set \"${mpvShaders.FSR}\"; show-text \"AMD FSR: ON\"";
      "Ctrl+Shift+F8" =
        "no-osd change-list glsl-shaders set \"${mpvShaders.SSimDownscaler}\"; show-text \"SSimDownscaler: ON\"";
      "Ctrl+Shift+\\" = "no-osd change-list glsl-shaders clr \"\"; show-text \"GLSL shaders cleared\"";

      # UOSC Menu (Useful since you have uosc installed)
      "m" = "script-binding uosc/menu";
      "s" = "script-binding uosc/subtitles";
      "a" = "script-binding uosc/audio";
    };

    config = {
      # --- General ---
      keep-open = "yes";
      save-position-on-quit = true;
      autofit = "85%x85%";
      cursor-autohide = 100;
      border = "no";
      msg-module = "yes";

      # --- Video Backend (Modern gpu-next) ---
      vo = "gpu-next";
      gpu-api = "vulkan";
      gpu-context = "auto"; # Better for multi-monitor/HDR negotiation
      hwdec = "nvdec"; # Native hardware decoding (fixes invalid format error)

      # --- HDR & Color Management ---
      target-colorspace-hint = "yes"; # Crucial for HDR passthrough to Wayland
      icc-profile-auto = "no"; # Let mpv handle color matching if profile exists
      dither-depth = "auto";
      temporal-dither = "yes";
      dither = "fruit";

      # --- Smooth Motion (Interpolation) ---
      video-sync = "display-resample";
      interpolation = "yes";
      tscale = "oversample"; # Reduces stutter on 60Hz screens

      # --- Scaling Filters ---
      # ewa_lanczossharp (Jinc) is the best all-rounder for gpu-next
      scale = "ewa_lanczossharp";
      dscale = "mitchell"; # Smoother for downscaling
      cscale = "spline36"; # High quality chroma scaling

      linear-upscaling = "yes";
      sigmoid-upscaling = "yes";
      correct-downscaling = "yes";

      # --- OSD & UI (Optimized for uosc) ---
      osc = "no"; # Required for uosc
      osd-bar = "no"; # Required for uosc
      osd-font = "Inter Tight Medium";
      osd-font-size = 30;

      # --- Audio ---
      ao = "pipewire";
      af = "acompressor=ratio=4,loudnorm";
      audio-pitch-correction = "yes";

      # --- Performance ---
      vulkan-swap-mode = "mailbox"; # Lower latency than FIFO
      gpu-shader-cache-dir = "~/.cache/mpv/shadercache";
      demuxer-max-bytes = "150MiB";
    };

    profiles = {
      # Auto-apply settings for 4K content
      "4k-content" = {
        profile-cond = "width >= 3840";
        vd-lavc-threads = 0; # Use all cores for 4K decode
        # Disable heavy shaders for 4K to save power
        glsl-shaders = "";
      };

      "hdr-force" = {
        # Used when you want to force PQ/BT2020 output
        target-prim = "dci-p3";
        target-trc = "srgb";
        tone-mapping = "bt.2446a"; # Modern tone mapping algorithm
        hdr-compute-peak = "yes";
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
