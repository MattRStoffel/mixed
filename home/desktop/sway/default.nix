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
        "${modifier}+space" = "exec fuzzel";
      };

      startup = [
        { command = "systemctl --user restart waybar"; always = true; }
        { command = "swaybg -i /home/matt/.config/desktop.png -m fill"; always = true; }
        { command = "blueman-applet"; always = true; }
      ];
    };

    extraConfig = import ./style.nix;
  };

  home.packages = with pkgs; [ swaybg ];
}
