{ pkgs, lib, ... }:
let
  c = (import ../theme.nix).colors;
in
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = rec {
      modifier = "Mod4";
      terminal  = "ghostty";
      bars      = [];

      window.titlebar   = false;
      floating.titlebar = false;

      keybindings = lib.mkOptionDefault {
        "${modifier}+space" = "exec fuzzel";
      };

      startup = [
        { command = "systemctl --user restart waybar"; always = true; }
        { command = "swaybg -i /home/matt/.config/desktop.png -m fill"; always = true; }
        { command = "blueman-applet"; always = true; }
      ];
    };

    extraConfig = ''
      gaps inner 6
      gaps outer 3

      default_border pixel 2
      client.focused #${c.accent} #${c.background} #${c.accent} #${c.accent}

      bindswitch lid:on  output eDP-1 disable
      bindswitch lid:off output eDP-1 enable

      bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
      bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
      bindsym XF86AudioMute        exec pactl set-sink-mute   @DEFAULT_SINK@ toggle
    '';
  };

  home.packages = with pkgs; [ swaybg ];
}
