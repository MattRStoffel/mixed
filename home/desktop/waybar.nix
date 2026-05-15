{ pkgs, ... }: {
  programs.waybar = {
    enable = true;

    settings = [{
      layer    = "top";
      position = "top";
      margin-top   = 10;
      margin-left  = 10;
      margin-right = 10;
      spacing      = 8;

      modules-left   = [ "sway/mode" ];
      modules-center = [ "clock" "sway/workspaces" ];
      modules-right  = [ "pulseaudio" "battery" "tray" ];

      "sway/workspaces" = {
        disable-scroll = true;
        all-outputs    = true;
        format         = "{icon}";
        format-icons."default" = "";
      };

      tray.spacing = 5;

      battery = {
        format       = "{icon}  {capacity}%";
        format-icons = [ "" "" "" "" "" ];
      };

      clock = {
        format         = "{:%I:%M %p}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      network = {
        format-wifi        = "  {essid}";
        format-ethernet    = "󰈀";
        format-disconnected = "󰖪";
      };

      pulseaudio = {
        format                = "{volume}% {icon} {format_source}";
        format-bluetooth       = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted           = " {format_source}";
        format-source          = "{volume}% ";
        format-source-muted    = "";
        format-icons = {
          headphone  = "";
          hands-free = "";
          headset    = "";
          phone      = "";
          portable   = "";
          car        = "";
          default    = [ "" "" "" ];
        };
        on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
      };
    }];

    style = ''
      * {
        font-family: "Cartograph CF Nerd Font", "JetBrainsMono Nerd Font";
        font-size: 13px;
        border: none;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
      }

      #workspaces,
      #window,
      #clock,
      #battery,
      #pulseaudio,
      #network,
      #tray {
        background: rgba(25, 23, 36, 0.8);
        color: #e0def4;
        padding: 2px 14px;
        border-radius: 8px;
        border: 1px solid rgba(156, 207, 216, 0.2);
      }

      #workspaces { padding: 0; }

      #workspaces button {
        padding: 0 10px;
        color: #6e6a86;
        border-radius: 5px;
        transition: all 0.3s ease;
      }

      #workspaces button.focused {
        color: #9ccfd8;
        background: #26233a;
      }

      #workspaces button.urgent { color: #eb6f92; }

      #window {
        background: transparent;
        border: none;
        font-style: italic;
      }

      #clock { color: #c4a7e7; }

      #battery.charging { color: #f6c177; }

      #battery.critical:not(.charging) {
        background-color: #eb6f92;
        color: #e0def4;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      @keyframes blink {
        to { background-color: #191724; color: #eb6f92; }
      }
    '';
  };

  home.packages = with pkgs; [ pavucontrol ];
}
