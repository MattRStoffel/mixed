{ pkgs, lib, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "ghostty";
      bars = [];
      # Window decoration removal
      window.titlebar = false;
      floating.titlebar = false;
      keybindings = lib.mkOptionDefault {
        "${modifier}+space" = "exec fuzzel";
      };
      startup = [
        { command = "systemctl --user restart waybar"; always = true; }
        { command = "swaybg -i /home/matt/.config/desktop.png -m fill"; always = true;}
      ];
    };
    extraConfig = ''
      # Gaps for the "floating" feel
      gaps inner 6
      gaps outer 3
      
      # Border settings
      default_border pixel 2
      client.focused #9ccfd8 #191724 #9ccfd8 #9ccfd8
      
      bindswitch lid:on output eDP-1 disable
      bindswitch lid:off output eDP-1 enable
      bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
      bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
      bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
    '';
    wrapperFeatures.gtk = true;
  };

  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      margin-top = 10;
      margin-left = 30;
      margin-right = 30;
      spacing = 8; # Gap between modules

      modules-left = [ "sway/mode" ];
      modules-center = [ "clock" "sway/workspaces" ];
      modules-right = [ "pulseaudio" "battery" "tray" ];

      "sway/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        format = "{icon}";
        format-icons = {
          "1" = "";
          "2" = "";
          "3" = "";
          "4" = "";
          "default" = "";
        };
      };

      tray = {
        spacing = 5; # Adjust this number for more or less space
      };

      "sway/window" = {
        format = "󱂬  {}";
        max-length = 50;
        rewrite = {
           "" = "Empty Space";
        };
      };

      battery = { 
        format = "{icon}  {capacity}%";
        format-icons = ["" "" "" "" ""];
      };

      clock = {
        format = "{:%I:%M %p}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      network = {
        format-wifi = "  {essid}";
        format-ethernet = "󰈀";
        format-disconnected = "󰖪";
      };

      pulseaudio = {
        format = "{icon}  {volume}%";
        format-muted = "󰝟";
        format-icons = { default = ["" "" ""]; };
        on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
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
        background: transparent; /* Makes the bar itself invisible */
      }

      /* Style every module as a floating pill */
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

      #workspaces {
        padding: 0;
      }

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

      #workspaces button.urgent {
        color: #eb6f92;
      }

      #window {
        background: transparent;
        border: none;
        font-style: italic;
      }

      #clock {
        color: #c4a7e7;
      }

      #battery.charging {
        color: #f6c177;
      }

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
programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Cartograph CF Nerd Font:size=13";
        prompt = "'❯  '";
        terminal = "ghostty";
        width = 40;
        horizontal-pad = 20;
        vertical-pad = 15;
        inner-pad = 10;
        line-height = 25;
      };

      colors = {
        # Format is RRGGBBAA
        background = "191724ff";     # Base (Rose Pine)
        text = "e0def4ff";           # Text
        match = "f6c177ff";          # Gold (highlighting typed characters)
        selection = "26233aff";      # Surface (slightly lighter background)
        selection-text = "9ccfd8ff"; # Foam (matching your focused window color)
        selection-match = "f6c177ff";
        border = "9ccfd833";         # Foam with transparency (matching Waybar rgba(156, 207, 216, 0.2))
      };

      border = {
        width = 1;                   # Matches Waybar border-width
        radius = 4;                  # Matches Waybar border-radius
      };
    };
  };
home.packages = with pkgs; [
  swaybg
];
}
