{ pkgs, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "ghostty";
    };
    extraConfig = ''
      # Disable internal display on lid close
      bindswitch lid:on output eDP-1 disable

      # Enable internal display on lid open
      bindswitch lid:off output eDP-1 enable
      
      # Volume up
      bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
      
      # Volume down
      bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
      
      # Mute/unmute
      bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
    '';
    wrapperFeatures.gtk = true; # Fixes GTK app theming
  };
}

