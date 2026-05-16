{ pkgs }:
[{
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
    format-wifi         = "  {essid}";
    format-ethernet     = "󰈀";
    format-disconnected = "󰖪";
  };

  pulseaudio = {
    format                 = "{volume}% {icon} {format_source}";
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
}]
