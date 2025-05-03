{...}: {
	home.file.".config/ghostty/config".text = ''
      window-height = 45
      window-width = 120

      theme = "Dracula"
      font-size = 14

      clipboard-read = "allow"
      clipboard-paste-protection = false

			quick-terminal-position = "center"
			quick-terminal-animation-duration = 0

      keybind = "global:cmd+grave_accent=toggle_quick_terminal"
	'';
}
