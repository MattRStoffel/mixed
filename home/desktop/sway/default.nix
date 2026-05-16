{ pkgs, lib, ... }:
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
        "${modifier}+space"    = "exec fuzzel";
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute"        = "exec pactl set-sink-mute   @DEFAULT_SINK@ toggle";
      };

      startup = [
        { command = "systemctl --user restart waybar"; always = true; }
        { command = "swaybg -i /home/matt/.config/desktop.png -m fill"; always = true; }
        { command = "blueman-applet"; always = true; }
      ];
    };

    extraConfig = import ./style.nix + ''
      bindswitch lid:on  output eDP-1 disable
      bindswitch lid:off output eDP-1 enable
    '';
  };

  home.packages = with pkgs; [ swaybg ];
}
