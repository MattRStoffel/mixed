{ pkgs, ... }:
let
  theme = import ../theme.nix;
  c = theme.colors;
  f = theme.fonts;
in
{
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
        format         = "{name}";
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
        font-family: "${f.ui}", "${f.mono}";
        font-size: ${toString f.size}px;
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
        background: ${c.backgroundAlpha};
        color: #${c.text};
        padding: 2px 14px;
        border-radius: 8px;
        border: 1px solid ${c.accentAlpha};
      }

      #workspaces { padding: 0; }

      #workspaces button {
        padding: 0 10px;
        color: #${c.subtle};
        border-radius: 5px;
        transition: all 0.3s ease;
      }

      #workspaces button.focused {
        color: #${c.accent};
        background: #${c.surface};
      }

      #workspaces button.urgent { color: #${c.urgent}; }

      #window {
        background: transparent;
        border: none;
        font-style: italic;
      }

      #clock { color: #${c.secondary}; }

      #battery.charging { color: #${c.highlight}; }

      #battery.critical:not(.charging) {
        background-color: #${c.urgent};
        color: #${c.text};
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      @keyframes blink {
        to { background-color: #${c.background}; color: #${c.urgent}; }
      }
    '';
  };

  home.packages = with pkgs; [ pavucontrol ];
}
