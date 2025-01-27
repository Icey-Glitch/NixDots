_: {
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical.target";
    };
    # Use the heredoc syntax for better readability
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 9px;
        min-height: 0;
        margin: 0px;
      }

      window#waybar {
        background : #24273a;
        color: #cad3f5;
      }

      #window, #clock, #battery, #cpu, #memory, #network,
      #pulseaudio, #custom-spotify, #tray, #mode {
        padding: 0 3px;
        margin: 0 2px;
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

      #mode, #battery.critical:not(.charging),
      #network.disconnected, #custom-spotify {
        color: white;
      }

      #battery.critical:not(.charging) {
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #network.disconnected {
        background: #f53c3c;
      }
    '';

    settings = {
      mainBar = {
        modules-left = ["hyprland/workspaces"];
        modules-right = ["temperature" "cpu" "memory" "network" "pulseaudio" "clock" "battery" "tray"];

        # Define module settings as separate attributes for clarity
        "hyprland/workspaces" = {
          format = "{name}";
        };

        "custom/nix" = {
          label = "󱄅";
          format = "󱄅";
        };

        "temperature" = {
          critical-threshold = 80;
          format = "<span color='#e88939'>{icon}</span> {temperatureC}°C";
          format-icons = ["" "" ""];
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
      };
    };
  };
}
