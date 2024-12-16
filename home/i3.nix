{
  pkgs,
  lib,
  ...
}: {

  home-manager.users.matt = {
    home.packages = with pkgs; [
      networkmanager
      dmenu
      i3status
      i3lock
      i3blocks
      brightnessctl
      pulseaudio 
      arandr # For adjusting screen layout
      autorandr # Auto Activate screens
      feh # For setting wallpaper
    ];
    programs.i3blocks = {
      enable = true;
      bars = 
{
  config = {
    ip = {
      command = "ifconfig | grep -A 5 wlan0 | awk '/inet /{print $2}'";
      interval = "once";
      color = "#91E78B";
    };
    weather = {
      command = "curl -Ss 'https://wttr.in/san_fransisco?0&T&Q' | cut -c 16- | head -2 | xargs echo";
      interval = 3600;
      color = "#A4C2F4";
    };
    date = {
      command = "date \"+%b %d\"";
      interval = 100;
    };
    time = {
      command = "date +%H:%M";
      interval = 5;
    };
  };
};
    };
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4"; # Sets the $mod key

        fonts = {
          names = [ "Hack Nerd Font" "FontAwesome5Free" ];
          style = "Bold Semi-Condensed";
          size = 10.0;
        };

        startup = [
  	  { command = "dex --autostart --environment i3"; always = true; notification = false; }
  	  { command = "xss-lock --transfer-sleep-lock -- i3lock --nofork"; always = true; notification = false; }
  	  { command = "nm-applet"; always = true; notification = false; }
  	  { command = "feh --bg-fill /home/matt/.mixed/assets/nix.png"; always = true; notification = false; }
  	  { command = "pactl set-sink-volume @DEFAULT_SINK@ +10%" ; notification = false; }
  	  { command = "pactl set-sink-volume @DEFAULT_SINK@ -10%" ; notification = false; }
  	  { command = "pactl set-sink-mute @DEFAULT_SINK@ toggle"; notification = false; }
  	  { command = "pactl set-source-mute @DEFAULT_SOURCE@ toggle"; notification = false; }
        ];

	terminal = "kitty";

        bars = [
          {
            position = "top";
            statusCommand = "i3blocks";
          }
        ];

        workspaceOutputAssign = [
	  { workspace = "1"; output = "HDMI-1"; }
	  { workspace = "2"; output = "DP-1"; }
	  { workspace = "3"; output = "eDP-1"; }
        ];

        gaps = {
          inner = 10;
          outer = 10; # Adjust gaps as needed
        };

        defaultWorkspace = "1"; # Default workspace
      };
    };
  };
}
