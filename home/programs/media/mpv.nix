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
    catppuccin.enable = false;
    defaultProfiles = [ "gpu-hq" ];

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
      # General Settings
      keep-open = true;
      snap-window = true;
      cursor-autohide = 100;
      save-position-on-quit = true;
      autofit = "85%x85%";
      border = false;
      msg-module = true;
      video-sync = "display-resample";

      # OSC/OSD Settings
      osc = false;
      osd-bar = false;
      osd-font = "'Inter Tight Medium'";
      osd-font-size = 30;
      osd-color = "#CCFFFFFF";
      osd-border-color = "#DD322640";
      osd-bar-align-y = -1;
      osd-border-size = 2;
      osd-bar-h = 1;
      osd-bar-w = 60;

      # Subtitles Settings
      slang = "eng,en,und";
      sub-auto = "fuzzy";
      subs-with-matching-audio = false;
      demuxer-mkv-subtitle-preroll = true;
      sub-fix-timing = false;

      # Audio Settings
      ao = "pipewire";
      af = "acompressor=ratio=4,loudnorm";
      audio-stream-silence = true;
      audio-file-auto = "fuzzy";
      audio-pitch-correction = true;
      alang = "jpn,jp,eng,en,enUS,en-US";

      # Video Settings
      vo = "gpu-next";
      gpu-api = "vulkan";
      gpu-context = "waylandvk";

      # CRITICAL: Use nvdec-copy to preserve YUV color space for HDR
      hwdec = "nvdec-copy";

      # Remove the vf line - it's not the issue
      video-output-levels = "full";

      # GPU settings
      gpu-shader-cache-dir = "~/.cache/mpv/shadercache";

      ###############
      # Color Space #
      ###############

      # CRITICAL: Disable target color space hints - let Wayland handle everything
      target-colorspace-hint = false;

      # Force Vulkan to use the right colorspace
      vulkan-swap-mode = "fifo";

      # Disable ICC profile to prevent color space interference
      icc-profile-auto = false;

      ##########
      # Dither #
      ##########

      dither-depth = "auto";
      temporal-dither = "yes";
      dither = "fruit";

      ##########
      # Deband #
      ##########

      deband = false;
      deband-iterations = 4;
      deband-threshold = 48;
      deband-range = 16;
      deband-grain = 24;

      scale-antiring = 0.6;
      dscale-antiring = 0.7;
      cscale-antiring = 0.7;

      ##########
      # Interp #
      ##########

      interpolation = false;
      tscale = "oversample";
      interpolation-preserve = true;

      # Scaling Settings
      linear-upscaling = true;
      sigmoid-upscaling = true;
      correct-downscaling = true;
      linear-downscaling = false;

      dscale = "lanczos";
      cscale = "lanczos";

      # Cache Settings
      demuxer-max-back-bytes = "100MiB";
      demuxer-max-bytes = 104857600;
    };

    profiles = {
      # HDR passthrough profile - let compositor handle tone mapping
      "hdr-passthrough" = {
        profile-desc = "HDR passthrough for HDR content";
        profile-cond = ''p["video-params/sig-peak"] and p["video-params/sig-peak"] > 1'';
        profile-restore = "copy";

        # Ensure nvdec-copy is used for HDR
        hwdec = "nvdec-copy";

        # Passthrough HDR metadata to compositor
        target-colorspace-hint = true;
        target-prim = "auto";
        target-trc = "auto";

        # Let Hyprland handle HDR
        tone-mapping = "auto";
        hdr-compute-peak = "auto";

        video-output-levels = "full";
        icc-profile-auto = false;
      };

      # SDR profile for non-HDR content
      "sdr" = {
        profile-desc = "SDR content";
        profile-cond = ''not (p["video-params/sig-peak"] and p["video-params/sig-peak"] > 1)'';
        profile-restore = "copy";

        target-peak = 203;
        target-prim = "bt.709";
        target-trc = "bt.1886";
        video-output-levels = "full";
        icc-profile-auto = false;
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
