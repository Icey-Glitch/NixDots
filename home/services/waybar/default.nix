{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  dependencies = with pkgs; [
    cfg.package
    inputs.gross.packages.${pkgs.system}.gross
    config.wayland.windowManager.hyprland.package
    bash
    blueberry
    bluez
    brillo
    coreutils
    dbus
    findutils
    gawk
    gnome.gnome-control-center
    gnused
    imagemagick
    jaq
    jc
    libnotify
    networkmanager
    pavucontrol
    playerctl
    procps
    pulseaudio
    ripgrep
    socat
    udev
    upower
    util-linux
    wget
    wireplumber
    wlogout
  ];
  cfg = config.programs.waybar;
in {
  programs.waybar = {
    enable = true;
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 9px;
        min-height: 0;
        margin: 0px;
      }
      nix {
        padding: 10px;
      }

      window#waybar {
        background : #24273a;
        color: #cad3f5;
      }

      #window {
        color: #e4e4e4;
        font-weight: bold;
      }

      #workspaces {
        padding: 0px;
        border-radius: 20px;
        background-color: #494d64;
        border: 1px solid #8aadf4;
      }

      #workspaces button {
        padding: 0;
        background: transparent;
        color: #ff8700;
        border: none;
        font-weight: bold;
        border-left: 1px solid #1b1d1e;
      }

      #workspaces button:first-child {
        border-left: none;
      }

      #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
      }

      #workspaces button.focused {
        background: #f5bde6;
        color: #f5bde6;
      }

      #workspaces button.urgent {
        background: #af005f;
        color: #1b1d1e;
      }

      #mode {
        background: #af005f;
        color: #1b1d1e;
      }

      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #custom-spotify, #tray, #mode {
        padding: 0 3px;
        margin: 0 2px;
      }

      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #custom-spotify, #tray, #mode {
        padding: 0 3px;
        margin: 0 2px;
      }

      @keyframes blink {
        to {
          background-color: #af005f;
        }
      }

      #battery.critical:not(.charging) {
        color: white;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #network.disconnected {
        background: #f53c3c;
      }

      #pulseaudio.muted {
      }

      #custom-spotify {
        color: rgb(102, 220, 105);
      }

    '';
    settings = {
      mainBar = {
        modules-left = ["hyprland/workspaces" "hyprland/submap"];
        modules-right = ["temperature" "cpu" "memory" "network" "pulseaudio" "clock" "battery" "tray"];

        "hyprland/submap" = {
          format = "{}";
        };

        "custom/nix" = {
          label = "󱄅";
          format = "󱄅";
        };

        "temperature" = {
          critical-threshold = 80;
          format = "<span color='#e88939'>{icon}</span> {temperatureC}°C";
          format-icons = ["" "" ""];
        };

        "cpu" = {
          format = " {usage}%";
          tooltip = false;
        };

        "memory" = {
          format = " {used:0.1f}G";
        };

        "network" = {
          family = "ipv4";
          format-wifi = "<span color='#589df6'></span> <span color='gray'>{essid}</span> {frequency} <span color='#589df6'>{signaldBm} dB</span> <span color='#589df6'>⇵</span> {bandwidthUpBits}/{bandwidthDownBits}";
          format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          interval = 5;
        };

        "pulseaudio" = {
          format = "{icon} {volume}% {format_source}";
          format-muted = "🔇 {format_source}";
          format-bluetooth = "{icon} {volume}% {format_source}";
          format-bluetooth-muted = "🔇 {format_source}";

          format-source = " {volume}%";
          format-source-muted = "";

          on-click = "ponymix -N -t sink toggle";
          on-click-right = "ponymix -N -t source toggle";
        };

        "clock" = {
          interval = 1;
          format = "⏰ {:%H:%M:%S}";
          tooltip-format = "{:%Y-%m-%d | %H:%M:%S}";
        };

        "battery" = {
          states = {
            good = 60;
            warning = 20;
            critical = 10;
          };
          weighted-average = true;
          format = "<span color='#e88939'>{icon}</span> {capacity}% ({time})";
          format-charging = "<span color='#e88939'>󰂄 </span> {capacity}%";
          format-plugged = "<span color='#e88939'>{icon} </span> {capacity}% ({time})";
          format-icons = ["" "" "" "" ""];
        };

        "tray" = {
          spacing = 10;
        };

        "mpd" = {
          format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ";
          format-disconnected = "Disconnected ";
          format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
          unknown-tag = "N/A";
          interval = 2;
          consume-icons = {
            on = " ";
          };
          random-icons = {
            off = "<span color=\"#f53c3c\"></span> ";
            on = " ";
          };
          repeat-icons = {
            on = " ";
          };
          single-icons = {
            on = "1 ";
          };
          state-icons = {
            paused = "";
            playing = "";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
        };
      };
    };
  };
}
